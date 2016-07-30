<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Pay to us</title>
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css"
	integrity="sha384-1q8mTJOASx8j1Au+a5WDVnPi2lkFfwwEAa8hDDdjZlpLegxhjVME1fgjWPGmkzs7"
	crossorigin="anonymous">
<script src="http://code.jquery.com/jquery-1.9.0.js"></script>
<script
	src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js"
	integrity="sha384-0mSbJDEHialfmuBBQP6A4Qrprq5OVfW37PRR3j5ELqxss1yVqOtnepnHVP9aJ7xS"
	crossorigin="anonymous"></script>
<script src="js/pay.js"></script>
</head>
<body>
	<div class="container">
		<form class="form-horizontal" role="form" id="payForm" method="POST">
			<fieldset>
				<legend>Payment</legend>
				<div class="form-group">
					<label class="col-sm-3 control-label" for="amount">Amount</label>
					<div class="col-sm-2">
						<input type="text" class="form-control" name="amount"
							id="card-number" placeholder="$"
							value="<%=request.getParameter("amount") == null ? "1.00" : request.getParameter("amount")%>">
					</div>
				</div>
				<div class="form-group">
					<label class="col-sm-3 control-label" for="card-holder-name">Name
						on Card</label>
					<div class="col-sm-9">
						<input type="text" class="form-control" name="card-holder-name"
							id="card-holder-name" placeholder="Card Holder's Name">
					</div>
				</div>
				<div class="form-group">
					<label class="col-sm-3 control-label" for="card-number">Card
						Number</label>
					<div class="col-sm-6">
						<input type="text" class="form-control" name="card-number"
							id="card-number" placeholder="Debit/Credit Card Number">
					</div>
				</div>
				<div class="form-group">
					<label class="col-sm-3 control-label" for="card-type">Card
						Type</label>
					<div class="col-sm-3">
						<select class="form-control" name="type" id="card-type">
							<option value="visa">Visa</option>
							<option value="mastercard">Master</option>
							<option value="amex">AMEX</option>
							<option value="jcb">JCB</option>
							<option value="discover">Discover</option>
						</select>
					</div>
				</div>
				<div class="form-group">
					<label class="col-sm-3 control-label" for="expiry-month">Expiration
						Date</label>
					<div class="col-sm-9">
						<div class="row">
							<div class="col-xs-3">
								<select class="form-control col-sm-2" name="expiry-month"
									id="expiry-month">
									<option>Month</option>
									<option value="01">01</option>
									<option value="02">02</option>
									<option value="03">03</option>
									<option value="04">04</option>
									<option value="05">05</option>
									<option value="06">06</option>
									<option value="07">07</option>
									<option value="08">08</option>
									<option value="09">09</option>
									<option value="10">10</option>
									<option value="11">11</option>
									<option value="12">12</option>
								</select>
							</div>
							<div class="col-xs-3">
								<select class="form-control" name="expiry-year">
									<option value="2016">2016</option>
									<option value="2017">2017</option>
									<option value="2018">2018</option>
									<option value="2019">2019</option>
									<option value="2020">2020</option>
									<option value="2021">2021</option>
									<option value="2022">2022</option>
									<option value="2023">2023</option>
								</select>
							</div>
						</div>
					</div>
				</div>
				<div class="form-group">
					<label class="col-sm-3 control-label" for="cvv">Card CVV</label>
					<div class="col-sm-3">
						<input type="text" class="form-control" name="cvv" id="cvv"
							placeholder="Security Code">
					</div>
				</div>
				<div class="form-group">
					<div class="col-sm-offset-3 col-sm-4">
						<button type="button" class="btn btn-success" onclick="pay()"
							id="btnPay">Pay Now</button>
					</div>
				</div>
				<div id="result" style="display: none;"></div>
			</fieldset>
		</form>

	</div>
</body>
<script language="javascript">
	function pay() {
		$("btnPay").html("Paying...");
		$("btnPay").attr('disabled', 'disabled')
		var postData = $("#payForm").serializeArray();
		var formURL = "directpay";
		$("#result").html("<img src=\"loading.gif\"/>");
		$("#result").show();
		$.ajax({
			url : formURL,
			type : "POST",
			data : postData,
			success : function(data, textStatus, jqXHR) {
				$("#result").html(data);
				$("btnPay").removeAttr('disabled');
			},
			error : function(jqXHR, textStatus, errorThrown) {
				$("#result").html(
						"<span style='color: red;'>" + textStatus + "</span>");
				$("btnPay").removeAttr('disabled');
			}
		});

	}
</script>
</html>