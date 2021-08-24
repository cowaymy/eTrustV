<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">

function fn_sendEmail(){

	var emailInfo = {
			emailTo: $("#emailTo").val(),
			emailSubject: $("#emailSubject").val(),
			emailContent: $("#emailContent").val()
	}

	if ($("#chkUseTemplate").is(":checked")){

		Common.ajax("POST", "/internalTestDummy/sendEmailWithVmTemplate.do", emailInfo, function(result) {
			  Common.alert(result.message);
		});

	} else {

		Common.ajax("POST", "/internalTestDummy/sendEmail.do", emailInfo, function(result) {
		      Common.alert(result.message);
		});

	}

}

</script>

<section class="email_table"><!-- email_table start -->
  <form id="dummyEmailForm" name="dummyEmailForm" action="#" method="post">
    <table class="type1"><!-- table start -->
      <caption>table</caption>
      <colgroup>
        <col style="width:140px" />
        <col style="width:*" />
      </colgroup>
      <tbody>
        <tr>
          <th scope="row">Email From</th>
          <td>${emailFrom}</td>
        </tr>
        <tr>
          <th scope="row">Email To</th>
          <td><input type="text" id="emailTo" name="emailTo" class="w100p" /></td>
        </tr>
        <tr>
          <th scope="row">Email Subject</th>
          <td><input type="text" id="emailSubject" name="emailSubject" class="w100p" /></td>
        </tr>
        <tr>
          <th scope="row">Email Content</th>
          <td><input type="text" id="emailContent" name="emailContent" class="w100p" /></td>
        </tr>
        <tr>
          <th scope="row">Use Template for Email Content. If checked, Email Content above will be ignored</th>
          <td><input type="checkbox" id="chkUseTemplate" name="chkUseTemplate" class="w100p" /></td>
        </tr>
      </tbody>
    </table><!-- table end -->

    <ul class="center_btns">
        <li><p class="btn_blue2 big"><a href="#" id="btnSendEmail" onclick="javascript:fn_sendEmail()">Send Email</a></p></li>
    </ul>
  </form>
</section><!-- email_table end -->