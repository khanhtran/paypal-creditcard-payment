package com.datasys;

import java.io.IOException;
import java.io.InputStream;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import com.paypal.api.payments.Amount;
import com.paypal.api.payments.CreditCard;
import com.paypal.api.payments.FundingInstrument;
import com.paypal.api.payments.Payer;
import com.paypal.api.payments.Payment;
import com.paypal.api.payments.Transaction;
import com.paypal.base.rest.APIContext;
import com.paypal.base.rest.OAuthTokenCredential;
import com.paypal.base.rest.PayPalRESTException;

/**
 * Servlet implementation class DirectPay
 */
public class DirectPay extends HttpServlet {
	private static final long serialVersionUID = 1L;
    private static final String CONFIG_FILE = "/WEB-INF/classes/directpay.config";
    static final Logger logger = LogManager.getLogger(DirectPay.class);
    /**
     * @see HttpServlet#HttpServlet()
     */
    public DirectPay() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.getWriter().append("Served at: ").append(request.getContextPath());
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		InputStream input = getServletContext().getResourceAsStream(CONFIG_FILE);
		Properties p = new Properties();
		p.load(input);
		logger.info(p);
		String mode = p.getProperty("mode");
		String clientId = p.getProperty("clientId");
		String clientSecrect = p.getProperty("clientSecrect");
		
		Map<String, String> sdkConfig = new HashMap<String, String>();
		sdkConfig.put("mode", mode);
		try {
			String accessToken = new OAuthTokenCredential(clientId, clientSecrect, sdkConfig).getAccessToken();
			APIContext apiContext = new APIContext(accessToken);
			apiContext.setConfigurationMap(sdkConfig);
			CreditCard creditCard = loadFromRequest(request);
			FundingInstrument fundingInstrument = new FundingInstrument();
			fundingInstrument.setCreditCard(creditCard);

			List<FundingInstrument> fundingInstrumentList = new ArrayList<FundingInstrument>();
			fundingInstrumentList.add(fundingInstrument);

			Payer payer = new Payer();
			payer.setFundingInstruments(fundingInstrumentList);
			payer.setPaymentMethod("credit_card");

			Amount amount = new Amount();
			amount.setCurrency("USD");
			float fAmount = Float.parseFloat(request.getParameter("amount"));
			String strAmount = new DecimalFormat("#.##").format(fAmount);
			amount.setTotal(strAmount);

			Transaction transaction = new Transaction();
			transaction.setDescription("Pay to DataSys");
			transaction.setAmount(amount);

			List<Transaction> transactions = new ArrayList<Transaction>();
			transactions.add(transaction);

			Payment payment = new Payment();
			payment.setIntent("sale");
			payment.setPayer(payer);
			payment.setTransactions(transactions);

			Payment createdPayment = payment.create(apiContext);
			String result = createdPayment.toJSON();
			
			response.getOutputStream().print(result);
			
		} catch (PayPalRESTException e) {
			e.printStackTrace();
			response.getOutputStream().print(e.toString());
//			throw new ServletException(e);
		}
	}
	private CreditCard loadFromRequest(HttpServletRequest request) {
		CreditCard creditCard = new CreditCard();
		creditCard.setType(request.getParameter("type"));
		
		creditCard.setFirstName(request.getParameter("card-holder-name"));
//		creditCard.setLastName(request.getParameter("lastName"));
		creditCard.setNumber(request.getParameter("card-number"));
		
		creditCard.setExpireMonth(Short.parseShort(request.getParameter("expiry-month")));
		creditCard.setExpireYear(Short.parseShort(request.getParameter("expiry-year")));
		creditCard.setCvv2(Integer.parseInt(request.getParameter("cvv")));
		
		return creditCard;
	}
}
