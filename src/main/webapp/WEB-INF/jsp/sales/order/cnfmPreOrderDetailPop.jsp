<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<script type="text/javaScript" language="javascript">

  $(document).ready(function(){

    // 20190925 KR-OHK Moblie Popup Setting
    Common.setMobilePopup(false, false, '');

    $('#txtCustName_RW').text($('#name').val());
    $('#txtCustNRIC_RW').text($('#nric').val());
    $('#txtProduct_RW').text($("#ordProudct option:selected").text());
    $('#txtPromotion_RW').text($("#ordPromo option:selected").text());
    $('#txtMemberCode_RW').text($('#salesmanCd').val());
    $('#txtMemberName_RW').text($('#salesmanNm').val());

    if ($("#compType option:selected").val() != undefined) {
      if ($("#compType option:selected").val() != "") {
        $('#trAddCmpt').removeClass("blind");
        $('#txtAddCmpt_RW').text($("#compType option:selected").text());
      }
    }

    if($('input:radio[name="advPay"]:checked').val() == 1) {
      $('#tr1').removeClass("blind");
      $('#txtAdvPayment_RW').text('YES');
    }

    //fn_loadAtchment('${atchFileGrpId}');
    if(myFileCaches != null){
        if(myFileCaches[1] != null) $('#txtSofFileName_RW').text(myFileCaches[1].file.name);
        if(myFileCaches[2] != null) $('#txtNricFileName_RW').text(myFileCaches[2].file.name);
        if(myFileCaches[3] != null) $('#txtPayFileName_RW').text(myFileCaches[3].file.name);
        if(myFileCaches[4] != null) $('#txtTrFileName_RW').text(myFileCaches[4].file.name);
        if(myFileCaches[5] != null) $('#txtOtherFileName_RW').text(myFileCaches[5].file.name);
        if(myFileCaches[6] != null) $('#txtOtherFileName2_RW').text(myFileCaches[6].file.name);
        if(myFileCaches[7] != null) $('#txtSofTncFileName_RW').text(myFileCaches[7].file.name);
        if(myFileCaches[8] != null) $('#txtMSofFileName_RW').text(myFileCaches[8].file.name);
        if(myFileCaches[9] != null) $('#txtMSofTncFileName_RW').text(myFileCaches[9].file.name);
    }

  });

  $(function(){
    $('#btnConfirm_RW').click(function() {
      if(fn_isExistESalesNo() == true) return false;

      if(fn_checkProductQuota() == true) return false;

      fn_doSavePreOrder();
    });
  });

  function fn_loadAtchment(atchFileGrpId) {
      Common.ajax("Get", "/sales/order/selectAttachList.do", {atchFileGrpId :atchFileGrpId} , function(result) {
          console.log(result);
         if(result) {
              if(result.length > 0) {
                  $("#attachTd").html("");
                  for ( var i = 0 ; i < result.length ; i++ ) {
                      switch (result[i].fileKeySeq){
                      case '1':
                          $(".input_text[id='txtSofFileName_RW").val(result[i].atchFileName);
                          console.log(result[i].atchFileName);
                          break;
                      case '2':
                          $(".input_text[id='txtNricFileName_RW']").val(result[i].atchFileName);
                          break;
                      case '3':
                          $(".input_text[id='txtPayFileName_RW']").val(result[i].atchFileName);
                          break;
                      case '4':
                          $(".input_text[id='txtTrFileName_RW']").val(result[i].atchFileName);
                          break;
                      case '5':
                          $(".input_text[id='txtOtherFileName_RW']").val(result[i].atchFileName);
                          break;
                      case '6':
                          $(".input_text[id='txtOtherFileName_RW']").val(result[i].atchFileName);
                          break;
                      case '7':
                          $(".input_text[id='txtSofTncFileName_RW']").val(result[i].atchFileName);
                          break;
                      case '8':
                          $(".input_text[id='txtMSofFileName_RW").val(result[i].atchFileName);
                          break;
                      case '9':
                          $(".input_text[id='txtMSofTncFileName_RW").val(result[i].atchFileName);
                          break;
                       default:
                           Common.alert("no files");
                      }
                  }

                  // 파일 다운
                 $(".input_text").dblclick(function() {
                      var oriFileName = $(this).val();
                      var fileGrpId;
                      var fileId;
                      for(var i = 0; i < result.length; i++) {
                          if(result[i].atchFileName == oriFileName) {
                              fileGrpId = result[i].atchFileGrpId;
                              fileId = result[i].atchFileId;
                          }
                      }
                      if(fileId != null) fn_atchViewDown(fileGrpId, fileId);
                  });
              }
          }
     });
  }

   function fn_atchViewDown(fileGrpId, fileId) {
      var data = {
              atchFileGrpId : fileGrpId,
              atchFileId : fileId
      };
      Common.ajax("GET", "/eAccounting/webInvoice/getAttachmentInfo.do", data, function(result) {
          console.log(result)
          var fileSubPath = result.fileSubPath;
          fileSubPath = fileSubPath.replace('\', '/'');
          console.log("/file/fileDownWeb.do?subPath=" + fileSubPath + "&fileName=" + result.physiclFileName + "&orignlFileNm=" + result.atchFileName);
          window.open("/file/fileDownWeb.do?subPath=" + fileSubPath + "&fileName=" + result.physiclFileName + "&orignlFileNm=" + result.atchFileName);
      });
  }

</script>
</head>
<body>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>eKey-in View</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#" id="btnCnfmOrderClose"><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:40%" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.text.custName" /></th>
    <td><span id="txtCustName_RW"></span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.nric" /></th>
    <td><span id="txtCustNRIC_RW"></span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.product" /></th>
    <td><span id="txtProduct_RW"></span></td>
</tr>
<tr id="trAddCmpt" class="blind">
    <th scope="row"><spring:message code="sal.text.AddCmpt" /></th>
    <td><span id="txtAddCmpt_RW"></span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.promo" /></th>
    <td><span id="txtPromotion_RW"></span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.hpCodyCd" /></th>
    <td><span id="txtMemberCode_RW"></span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.hpCodyNm" /></th>
    <td><span id="txtMemberName_RW"></span></td>
</tr>
<tr id="tr1" class="blind">
    <th scope="row"><spring:message code="sal.text.advPay" /></th>
    <td><span id="txtAdvPayment_RW"></span></td>
</tr>
<tr>
<td colspan="2" scope="row"><h2>Attachment area</h2></td>
<tr>
<tr>
    <th scope="row">Sales Order Form (SOF)</th>
    <!-- <td><label><input type='text' class='input_text' readonly='readonly' id='txtSofFileName_RW'/></label></td> -->
    <td><span id="txtSofFileName_RW"></span></td>
</tr>
<tr>
    <th scope="row">Sales Order Form's T&C (SOF T&C)</th>
    <!-- <td><label><input type='text' class='input_text' readonly='readonly' id='txtSofFileName_RW'/></label></td> -->
    <td><span id="txtSofTncFileName_RW"></span></td>
</tr>
<tr>
    <th scope="row">NRIC & Bank Card</th>
    <!-- <td><label><input type='text' class='input_text' readonly='readonly' id='txtNricFileName_RW'/></label></td> -->
    <td><span id="txtNricFileName_RW"></span></td>
</tr>
<tr>
    <th scope="row">Payment document</th>
    <!-- <td><label><input type='text' class='input_text' readonly='readonly' id='txtPayFileName_RW'/></label></td> -->
    <td><span id="txtPayFileName_RW"></span></td>
</tr>
<tr>
    <th scope="row">Coway temporary receipt (TR)</th>
    <!-- <td><label><input type='text' class='input_text' readonly='readonly' id='txtTrFileName_RW'/></label></td> -->
    <td><span id="txtTrFileName_RW"></span></td>
</tr>
<tr>
    <th scope="row">Declaration letter/Others form</th>
    <!-- <td><label><input type='text' class='input_text' readonly='readonly' id='txtOtherFileName_RW'/></label></td> -->
    <td><span id="txtOtherFileName_RW"></span></td>
</tr>
<tr>
    <th scope="row">Declaration letter/Others form</th>
    <td><span id="txtOtherFileName2_RW"></span></td>
</tr>

<tr>
   <th scope="row">Mattress Sales Order Form (MSOF)</th>
   <td><span id="txtMSofFileName_RW"></span></td>
 </tr>
<tr>
   <th scope="row">Mattress Sales Order Form's T&C (MSOF T&C)</th>
   <td><span id="txtMSofTncFileName_RW"></span></td>
</tr>

</tbody>
</table><!-- table end -->

<ul class="center_btns">
    <li><p><span style="line-height:34px;"><spring:message code="sal.msg.ordRegDtl" /></span></p></li>
    <li><p class="btn_blue2 big"><a id="btnConfirm_RW" href="#"><spring:message code="sal.btn.ok" /></a></p></li>
<!--
    <li><p class="btn_blue2 big"><a id="btnBack_RW" href="#">Back</a></p></li>
-->
</ul>
</section><!-- pop_body end -->

</div><!-- popup_wrap end -->

</body>
</html>