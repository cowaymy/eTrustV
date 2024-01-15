<script type="text/javaScript" language="javascript">

    var sms1 = "${paymentInfo.sms1}";
    var sms2 = "${paymentInfo.sms2}";
    var email1 = "${paymentInfo.email1}";
    var email2 = "${paymentInfo.email2}";

    $(document).ready(function(){

     // Masking pen (display last 4)

  	var maskedSms1 = sms1.substr(0,3) + sms1.substr(3,sms1.length-7).replace(/[0-9]/g, "*") + sms1.substr(-4);
  	var maskedSms2 = sms2.substr(0,3) + sms2.substr(3,sms2.length-7).replace(/[0-9]/g, "*") + sms2.substr(-4);

  	var maskedEmail1 = "";
  	var prefix1= email1.substr(0, email1.lastIndexOf("@"));
      var postfix1= email1.substr(email1.lastIndexOf("@"));
      for(var i=0; i<prefix1.length; i++){
          if(i == 0 || i == prefix1.length - 1) {
          	maskedEmail1 = maskedEmail1 + prefix1[i].toString();
          }
          else {
          	maskedEmail1 = maskedEmail1 + "*";
          }
      }
      maskedEmail1 =maskedEmail1 +postfix1;

      var maskedEmail2 = "";
      var prefix2= email2.substr(0, email2.lastIndexOf("@"));
      var postfix2= email2.substr(email2.lastIndexOf("@"));
      for(var i=0; i<prefix2.length; i++){
          if(i == 0 || i == prefix1.length - 1) {
              maskedEmail2 = maskedEmail2 + prefix2[i].toString();
          }
          else {
              maskedEmail2 = maskedEmail2 + "*";
          }
      }
      maskedEmail2 =maskedEmail2 +postfix2;

      $("#notification_sms1").html(maskedSms1);
      // Appear NRIC on hover over field
      $("#notification_sms1").hover(function() {
          $("#notification_sms1").html(sms1);
      }).mouseout(function() {
          $("#notification_sms1").html(maskedSms1);
      });
      $("#imgHover1").hover(function() {
          $("#notification_sms1").html(sms1);
      }).mouseout(function() {
          $("#notification_sms1").html(maskedSms1);
      });

      $("#notification_sms2").html(maskedSms2);
      // Appear NRIC on hover over field
      $("#notification_sms2").hover(function() {
          $("#notification_sms2").html(sms2);
      }).mouseout(function() {
          $("#notification_sms2").html(maskedSms2);
      });
      $("#imgHover2").hover(function() {
          $("#notification_sms2").html(sms2);
      }).mouseout(function() {
          $("#notification_sms2").html(maskedSms2);
      });

      $("#notification_email1").html(maskedEmail1);
      // Appear NRIC on hover over field
      $("#notification_email1").hover(function() {
          $("#notification_email1").html(email1);
      }).mouseout(function() {
          $("#notification_email1").html(maskedEmail1);
      });
      $("#imgHover3").hover(function() {
          $("#notification_email1").html(email1);
      }).mouseout(function() {
          $("#notification_email1").html(maskedEmail1);
      });

      $("#notification_email2").html(maskedEmail2);
      // Appear NRIC on hover over field
      $("#notification_email2").hover(function() {
          $("#notification_email2").html(email2);
      }).mouseout(function() {
          $("#notification_email2").html(maskedEmail2);
      });
      $("#imgHover4").hover(function() {
          $("#notification_email2").html(email2);
      }).mouseout(function() {
          $("#notification_email2").html(maskedEmail2);
      });
    });

</script>

<article class="tap_area"><!-- tap_area start -->
<aside class="title_line"><!-- title_line start -->
<h3>E-Notification</h3>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:160px" />
    <col style="width:*" />
    <col style="width:170px" />
    <col style="width:*" />

</colgroup>
<tbody>
<tr>
    <th scope="row" colspan='1'>SMS</th>
    <td><a href="#" class="search_btn" id="imgHover1"><img style="height:70%" src="${pageContext.request.contextPath}/resources/images/common/nricEye2.png" /></a>
        <span id="notification_sms1"></span>
    </td>
    <th scope="row">SMS 2</th>
    <td><a href="#" class="search_btn" id="imgHover2"><img style="height:70%" src="${pageContext.request.contextPath}/resources/images/common/nricEye2.png" /></a>
        <span id="notification_sms2"></span>
    </td>
</tr>
<tr>
    <th scope="row">E-mail Address</th>
    <td><a href="#" class="search_btn" id="imgHover3"><img style="height:70%" src="${pageContext.request.contextPath}/resources/images/common/nricEye2.png" /></a>
        <span id="notification_email1"></span>
    </td>
    <th scope="row">E-mail Address 2</th>
    <td><a href="#" class="search_btn" id="imgHover4"><img style="height:70%" src="${pageContext.request.contextPath}/resources/images/common/nricEye2.png" /></a>
        <span id="notification_email2"></span>
    </td></tr>
</tbody>
</table><!-- table end -->
</article><!-- tap_area end -->