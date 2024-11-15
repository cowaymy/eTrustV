<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javaScript" language="javascript">
  var myFileCaches = {};
  var update = new Array();
  var remove = new Array();
  var atchFileGroupId = 0;
  var cifId = 0;
  var otherFile1Id = 0;
  var otherFile2Id = 0;
  var otherFile3Id = 0;
  var otherFile4Id = 0;
  var otherFile5Id = 0;
  var otherFile6Id = 0;

  var cifFileName = "";
  var otherFileName1 = "";
  var otherFileName2 = "";
  var otherFileName3 = "";
  var otherFileName4 = "";
  var otherFileName5 = "";
  var otherFileName6 = "";
  var attachmentInfoList;
  var custType = '${mobileAutoDebitDetail.custType}';

  $(document).ready(function() {
    if(undefinedCheck('${mobileAutoDebitDetail.atchFileGroupId}','number') > 0){
        atchFileGroupId = parseInt('${mobileAutoDebitDetail.atchFileGroupId}');
    }

    getRejectReasonCodeOption();
    fn_attachmentButtonRegister();

    loadGeneralInfoData();
    loadPaymentInfoData();
    loadStatusInfoData();
    loadAttachmentData();
    loadThirdPartyCustData();
    checkStatusForConditionalDisable();

    //Ledgers
    $('#btnLedger1').click(function() {
      Common.popupWin("frmLedger", "/sales/order/orderLedgerViewPop.do", {width : "1000px", height : "720", resizable: "no", scrollbars: "no"});
    });

    $('#btnLedger2').click(function() {
      Common.popupWin("frmLedger", "/sales/order/orderLedger2ViewPop.do", {width : "1000px", height : "720", resizable: "no", scrollbars: "no"});
    });

    //Ledgers
    $('#btnOrdDtlClose').click(function() {
      $('#_divAutoDebitDetailPop').remove();
    });

    $('#btnAutoDebitDetailClose').click(function() {
      fn_close();
    });

    $('#btnAddThirdPartyCust').click(function() {
      // Common.popupDiv("searchForm", "/sales/customer/customerRegistPop.do", { width : "1200px", height : "630x" });
       Common.popupDiv("/sales/customer/customerRegistPop.do", null, null, true);
    });

    $('#btnThirdPartyCustSearch').click(function() {
        $('#thrdPartyId').val('');
        $('#thrdPartyType').text('');
        $('#thrdPartyName').text('');
        // $('#txtThrdPartyNric').text('');
        $('#txtThrdPartyNric').val('');
        fn_maskingData('ThrdPartyNric', $('#txtThrdPartyNric'));
        Common.popupDiv("/common/customerPop.do", {
           callPrgm : "loadThirdPartyPopData"
         }, null, true);
    });

    $('#action').change(function() {
      if($(this).val() == "5") {
        $('#rejectReasonCodeList').attr('disabled',true);
      } else {
        $('#rejectReasonCodeList').attr('disabled',false);
      }
    });
  });

  function loadThirdPartyCustData(){
    var custData ="${thirdPartyCustomerInfo}";
    if(custData != null && custData != ""){
        loadThirdPartyPopData(JSON.parse(custData));
    }
  }

  function loadThirdPartyPopData(custData){
    if(custData != null && custData != ""){
      $('#thrdPartyId').val(custData.custId);
      $('#thrdPartyType').text(custData.codeName1);
      $('#thrdPartyName').text(custData.name);
      //$('#txtThrdPartyNric').text(custData.nric);
      $('#txtThrdPartyNric').val(custData.nric);
      fn_maskingData('ThrdPartyNric', $('#txtThrdPartyNric'));
    } else {
      Common.alert('<spring:message code="sal.alert.msg.thirdPartyNotFoundmsg" />');
    }
  }

  function checkStatusForConditionalDisable(){
    var actionStatus = "${mobileAutoDebitDetail.stusCodeId}";
    if(actionStatus == "5" || actionStatus == "6"){
      $('#action').attr('disabled',true);
      $('#rejectReasonCodeList').attr('disabled',true);
      $('#remarks').attr('disabled',true);
      $('#btnSave').hide();
      $('.upload_btn').hide();
      $('.remove_btn').hide();
      $('#btnAddThirdPartyCust').hide();
      $('#btnThirdPartyCustSearch').hide();
    }
  }

  function fn_attachmentButtonRegister(){
    $('#cardImageFile').change(function(evt) {
      var file = evt.target.files[0];
      if(file == null) {
        if(myFileCaches[1] != null){
          delete myFileCaches[1];
        }
        if(cifId != '0'){
          remove.push(cifId);
        }
      } else if(file.name != cifFileName) {
        myFileCaches[1] = {file:file};
        if(cifFileName != "") {
          update.push(cifId);
        }
      }
    });

    //renamed as 3rd party letter
    $('#otherFile1').change(function(evt) {
      var file = evt.target.files[0];
      if(file == null) {
        if(myFileCaches[2] != null){
          delete myFileCaches[2];
        }
        if(otherFile1Id != '0'){
          remove.push(otherFile1Id);
        }
      }else if(file.name != otherFileName1) {
        myFileCaches[2] = {file:file};
        if (otherFileName1 != "") {
          update.push(otherFile1Id);
        }
      }
    });

    //renamed as 3rd party nric copy
    $('#otherFile2').change(function(evt) {
      var file = evt.target.files[0];
      if(file == null) {
        if(myFileCaches[3] != null){
          delete myFileCaches[3];
        }
        if(otherFile2Id != '0'){
          remove.push(otherFile2Id);
        }
      } else if (file.name != otherFileName2) {
        myFileCaches[3] = {file:file};
        if (otherFileName2 != "") {
          update.push(otherFile2Id);
        }
      }
    });

    //renamed as business registration form copy
    $('#otherFile3').change(function(evt) {
      var file = evt.target.files[0];
      if(file == null) {
        if(myFileCaches[4] != null){
          delete myFileCaches[4];
        }
        if(otherFile3Id != '0'){
          remove.push(otherFile3Id);
        }
      } else if (file.name != otherFileName3) {
        myFileCaches[4] = {file:file};
        if (otherFileName3 != "") {
          update.push(otherFile3Id);
        }
      }
    });

    $('#otherFile4').change(function(evt) {
      var file = evt.target.files[0];
      if(file == null) {
        if(myFileCaches[5] != null){
          delete myFileCaches[5];
        }
        if(otherFile4Id != '0'){
          remove.push(otherFile4Id);
        }
      } else if(file.name != otherFileName4) {
        myFileCaches[5] = {file:file};
        if(otherFileName4 != "") {
          update.push(otherFile4Id);
        }
      }
    });

    $('#otherFile5').change(function(evt) {
      var file = evt.target.files[0];
       if(file == null) {
         if(myFileCaches[6] != null){
           delete myFileCaches[6];
         }
         if(otherFile5Id != '0'){
           remove.push(otherFile5Id);
         }
       }else if(file.name != otherFileName5) {
         myFileCaches[6] = {file:file};
         if(otherFileName5 != "") {
           update.push(otherFile5Id);
        }
       }
    });

    $('#otherFile6').change(function(evt) {
      var file = evt.target.files[0];
      if(file == null) {
        if(myFileCaches[7] != null){
          delete myFileCaches[7];
        }
        if(otherFile6Id != '0'){
          remove.push(otherFile6Id);
        }
      } else if (file.name != otherFileName6) {
        myFileCaches[7] = {file:file};
        if(otherFileName6 != "") {
          update.push(otherFile6Id);
        }
      }
    });

    if(custType.toUpperCase() == "COMPANY"){
       $('.optional2').hide();//remove
       $('.optional3').hide();//remove
       $('.optional4').hide();//remove
       $('.optionalStar2').show();
       $('.optionalStar3').show();
       $('.optionalStar4').show();
    } else {
      if("${mobileAutoDebitDetail.isThirdPartyPayment}" == "1"){
        $('.optional2').hide();//remove
        $('.optional3').hide();//remove
        $('.optional4').show();//remove
        $('.optionalStar2').show();
        $('.optionalStar3').show();
        $('.optionalStar4').hide();
      } else {
        $('.optional2').show();//remove
        $('.optional3').show();//remove
        $('.optional4').show();//remove
        $('.optionalStar2').hide();
        $('.optionalStar3').hide();
        $('.optionalStar4').hide();
      }
    }
  }

  function saveDataValidation(){
    var action = $('#action').val();
    var rejectReasonCode = $('#rejectReasonCodeList').val();
    var remarks = $('#remarks').val();
    var cardImageFileAttachment = $('#cardImageFile').val();
    var thirdPartyLetterAttachment = $('#otherFile1').val();
    var thirdPartyNricAttachment = $('#otherFile2').val();
    var businessRegistrationFormAttachment = $('#otherFile3').val();

    if(action == ""){
      Common.alert('Please select an action');
      return;
    }

    if(action == "6" && rejectReasonCode == ""){
      Common.alert('Reject Reason Code is compulsory for Rejected Action');
      return;
    }

    if(action == "6" && rejectReasonCode == "3501" && remarks == ""){
      Common.alert('Remarks is compulsory for Rejected Action Others');
      return;
    }

    if(cardImageFileAttachment == null || cardImageFileAttachment== ""){
      if(cifId == 0){
        Common.alert('Card Image Attachment is required');
        return;
      }
    }

    if(custType.toUpperCase() == "COMPANY"){
      if(thirdPartyLetterAttachment == null || thirdPartyLetterAttachment== ""){
        if(cifId == 0){
          Common.alert('3rd Party Letter Attachment is required');
          return;
        }
      }

      if(thirdPartyNricAttachment == null || thirdPartyNricAttachment== ""){
        if(cifId == 0){
          Common.alert('Third Party NRIC Attachment is required');
          return;
        }
      }

      if(businessRegistrationFormAttachment == null || businessRegistrationFormAttachment== ""){
        if(cifId == 0){
          Common.alert('Business Registration Form Attachment is required');
          return;
        }
      }
    } else {
      if("${mobileAutoDebitDetail.isThirdPartyPayment}" == "1"){
        if(thirdPartyLetterAttachment == null || thirdPartyLetterAttachment== ""){
          if(cifId == 0){
            Common.alert('3rd Party Letter Attachment is required');
            return;
          }
        }

        if(thirdPartyNricAttachment == null || thirdPartyNricAttachment== ""){
          if(cifId == 0){
            Common.alert('Third Party NRIC Attachment is required');
            return;
          }
        }
      }
    }

    if(action =="5"){
      $("#rejectReasonCodeList option[value='']").attr("selected", true);
    }

    if(action != "6"){
      if("${mobileAutoDebitDetail.isThirdPartyPayment}" == "1"){
        if(undefinedCheck($('#thrdPartyId').val()) == ""){
          Common.alert('Third Party Customer is required');
          return;
        }
      }
    }

    doSave();
  }

  function doSave(){
    //update data
    var data = { statusCodeId : $('#action').val(),
                       rejectReasonCode : $('#rejectReasonCodeList').val(),
                       remarks : $('#remarks').val(),
                       padId: "${mobileAutoDebitDetail.padId}",
                       thirdPartyCustId: $('#thrdPartyId').val()
    }

    //attachment data
    var formData = new FormData();
    formData.append("update", JSON.stringify(update).replace(/[\[\]\"]/gi, ''));
    formData.append("remove", JSON.stringify(remove).replace(/[\[\]\"]/gi, ''));
    formData.append("atchFileGroupId", atchFileGroupId);
    $.each(myFileCaches, function(n, v) {
      formData.append(n, v.file);
    });

    Common.ajaxFile("/payment/mobileautodebit/attachmentAutoDebitFileUpdate.do", formData, function(result) {
      if(result.code == 99){
        Common.alert("Attachment Upload Failed" + DEFAULT_DELIMITER + result.message);
      } else {
        Common.ajax("POST", "/payment/mobileautodebit/updateAction.do", data, function(result1) {
        if(result1.code == 00){
          selectList();
          fn_close();
        } else {
          Common.alert(result1.message);
        }
      });
      }
    });
  }

  function fn_close() {
    $("#popup_wrap").remove();
  }

  function getRejectReasonCodeOption(){
    doGetComboData('/payment/mobileautodebit/selectRejectReasonCodeOption.do', '', '', 'rejectReasonCodeList', 'S', 'setRejectReasonCode');
  }

  function setRejectReasonCode(){
    var failReasonCode = "${mobileAutoDebitDetail.failReasonCode}";
    if(failReasonCode != null){
      $("#rejectReasonCodeList option[value='"+ failReasonCode +"']").attr("selected", true);
    }
  }

  function loadGeneralInfoData(){

	 var custName ="${mobileAutoDebitDetail.name}";

    $('#preAutoDebitNo').val("${mobileAutoDebitDetail.padNo}");
    $('#spanPreAutoDebitNo').text("${mobileAutoDebitDetail.padNo}");

    $('#padKeyInDate').val("${mobileAutoDebitDetail.crtDt}");
    $('#spanPadKeyInDate').text("${mobileAutoDebitDetail.crtDt}");

    $('#orderNumber').val("${mobileAutoDebitDetail.salesOrdNo}");
    $('#spanOrderNumber').text("${mobileAutoDebitDetail.salesOrdNo}");

    $('#orderDate').val("${mobileAutoDebitDetail.salesDt}");
    $('#spanOrderDate').text("${mobileAutoDebitDetail.salesDt}");

    $('#custType').val("${mobileAutoDebitDetail.custType}");
    $('#spanCustType').text("${mobileAutoDebitDetail.custType}");

    $('#productName').val("${mobileAutoDebitDetail.stkDesc}");
    $('#spanProductName').text("${mobileAutoDebitDetail.stkDesc}");

    $('#customerName').val(custName);
    $('#spanCustomerName').text(custName);

    $('#monthlyRentalFee').val("${mobileAutoDebitDetail.mthRentAmt}");
    $('#spanMonthlyRentalFee').text("${mobileAutoDebitDetail.mthRentAmt}");

    $('#nricCompanyNumber').val("${mobileAutoDebitDetail.nric}");
    $("#pCompanyNumber").show();
    fn_maskingData('CompanyNumber', $('#nricCompanyNumber'));

    $('#rentalStatus').val("${mobileAutoDebitDetail.rentalStatus}");
    $('#spanRentalStatus').text("${mobileAutoDebitDetail.rentalStatus}");
  }

  function loadPaymentInfoData(){
    if("${mobileAutoDebitDetail.isThirdPartyPayment}" == "1"){
      $('#thirdPartyPayCheckBox').prop('checked', true);
    }
    $('#cardNumber').val("${customerCreditCardEnrollInfo.custOriCrcNo}");
    $('#visaMasterType').val("${customerCreditCardEnrollInfo.cardProvider}");
    $('#custCrcName').val("${customerCreditCardEnrollInfo.custCrcOwner}");
    $('#cardExpiryDate').val("${customerCreditCardEnrollInfo.custCrcExpr}");
    $('#issueBank').val("${customerCreditCardEnrollInfo.issueBank}");
    $('#custCardType').val("${customerCreditCardEnrollInfo.cardType}");

    checkThirdPartyDisplayCondition();
  }

  function checkThirdPartyDisplayCondition() {
    if("${mobileAutoDebitDetail.isThirdPartyPayment}" == "1"){
      $('.thirdPartySection').show();
    } else{
      $('.thirdPartySection').hide();
    }
  }

  function undefinedCheck(value, type){
    var retVal;

    if (value == undefined || value == "undefined" || value == null || value == "null" || $.trim(value).length == 0) {
      if (type && type == "number") {
        retVal = 0;
      } else {
        retVal = "";
      }
    } else {
      if (type && type == "number") {
        retVal = Number(value);
      }else{
        retVal = value;
      }
    }
    return retVal;
  };

  function fn_atchViewDown(fileData) {
    var fileSubPath = fileData.CI_FILE_SUB_PATH;
    fileSubPath = fileSubPath.replace('\', '/'');

    if(fileData.fileExtsn == "jpg" || fileData.fileExtsn == "png" || fileData.fileExtsn == "gif") {
      window.open(DEFAULT_RESOURCE_FILE + fileSubPath + '/' + fileData.CI_PHYSICL_FILE_NAME);
    } else {
      window.open("/file/fileDownWeb.do?subPath=" + fileSubPath + "&fileName=" + fileData.CI_PHYSICL_FILE_NAME + "&orignlFileNm=" + fileData.CI_ATCH_FILE_NAME);
    }
  }

  function loadAttachmentData(){
    attachmentInfoList = ${autoDebitAttachmentInfo};

    if(attachmentInfoList){
      if(attachmentInfoList.length > 0) {
       for (var i = 0; i < attachmentInfoList.length; i++) {
         switch (attachmentInfoList[i].FILE_KEY_SEQ){
         case '1':
           cifId = attachmentInfoList[i].CI_ATCH_FILE_ID;
           cifFileName = attachmentInfoList[i].CI_ATCH_FILE_NAME;
           $(".input_text[id='cardImageFileTxt']").val(cifFileName);
           break;
         case '2':
           otherFile1Id = attachmentInfoList[i].CI_ATCH_FILE_ID;
           otherFileName1 = attachmentInfoList[i].CI_ATCH_FILE_NAME;
           $(".input_text[id='otherFileTxt1']").val(otherFileName1);
           break;
         case '3':
           otherFile2Id = attachmentInfoList[i].CI_ATCH_FILE_ID;
           otherFileName2 = attachmentInfoList[i].CI_ATCH_FILE_NAME;
           $(".input_text[id='otherFileTxt2']").val(otherFileName2);
           break;
         case '4':
          otherFile3Id = attachmentInfoList[i].CI_ATCH_FILE_ID;
           otherFileName3 = attachmentInfoList[i].CI_ATCH_FILE_NAME;
           $(".input_text[id='otherFileTxt3']").val(otherFileName3);
           break;
         case '5':
           otherFile4Id = attachmentInfoList[i].CI_ATCH_FILE_ID;
           otherFileName4 = attachmentInfoList[i].CI_ATCH_FILE_NAME;
           $(".input_text[id='otherFileTxt4']").val(otherFileName4);
           break;
         case '6':
           otherFile5Id = attachmentInfoList[i].CI_ATCH_FILE_ID;
           otherFileName5 = attachmentInfoList[i].CI_ATCH_FILE_NAME;
           $(".input_text[id='otherFileTxt5']").val(otherFileName5);
           break;
         case '7':
           otherFile6Id = attachmentInfoList[i].CI_ATCH_FILE_ID;
           otherFileName6 = attachmentInfoList[i].CI_ATCH_FILE_NAME;
           $(".input_text[id='otherFileTxt6']").val(otherFileName6);
           break;
         default:
           // Common.alert("No attachment found.");
           break;
         }
       }

       $(".input_text").dblclick(function() {
         var oriFileName = $(this).val();
         var attachmentInfo;
         var fileId;
         var fileGrpId;
         for (var i = 0; i < attachmentInfoList.length; i++) {
          if(attachmentInfoList[i].CI_ATCH_FILE_NAME == oriFileName) {
            fileGrpId = atchFileGroupId;
            fileId = attachmentInfoList[i].CI_ATCH_FILE_ID;
            attachmentInfo = attachmentInfoList[i];
          }
        }
        if(fileId != null) fn_atchViewDown(attachmentInfo);
      });
      }
    }
  }

  function loadStatusInfoData(){
    var actionStatus = "${mobileAutoDebitDetail.stusCodeId}";
    var remarks = "${mobileAutoDebitDetail.remarks}";
    if(actionStatus != null){
      $("#action option[value='"+ actionStatus +"']").attr("selected", true);
    }
    if(remarks != null){
      var decodeRemark= decodeHtml(remarks);
      $('#remarks').val(decodeRemark.replaceAll("<br>","\n"));
    }
  }

  function decodeHtml(str) {
    var map = {
      '&amp;': '&',
      '&lt;': '<',
      '&gt;': '>',
      '&quot;': '"',
      '&#039;': "'"
    };
    return str.replace(/&amp;|&lt;|&gt;|&quot;|&#039;/g, function(m) {return map[m];});
  }

  //Attachments
  function fn_removeFile(name){
    if(name == "CIF") {
      $("#cardImageFile").val("");
      $(".input_text[id='cardImageFileTxt']").val("");
      $('#cardImageFile').change();
    }else if(name == "OTH1") {
      $("#otherFile1").val("");
      $(".input_text[id='otherFileTxt1']").val("");
      $('#otherFile1').change();
    }else if(name == "OTH2") {
      $("#otherFile2").val("");
      $(".input_text[id='otherFileTxt2']").val("");
      $('#otherFile2').change();
    }else if(name == "OTH3") {
      $("#otherFile3").val("");
      $(".input_text[id='otherFileTxt3']").val("");
      $('#otherFile3').change();
    }else if(name == "OTH4") {
      $("#otherFile4").val("");
      $(".input_text[id='otherFileTxt4']").val("");
      $('#otherFile4').change();
    }else if(name == "OTH5") {
      $("#otherFile5").val("");
      $(".input_text[id='otherFileTxt5']").val("");
      $('#otherFile5').change();
    }else if(name == "OTH6") {
      $("#otherFile6").val("");
      $(".input_text[id='otherFileTxt6']").val("");
      $('#otherFile6').change();
    }
  }

  function fn_maskingData(ind, obj) {
    var maskedVal = (obj.val()).substr(-4).padStart((obj.val()).length, '*');
      $("#span" + ind).html(maskedVal);
      // Appear NRIC on hover over field
      $("#span" + ind).hover(function() {
          $("#span" + ind).html(obj.val());
      }).mouseout(function() {
          $("#span" + ind).html(maskedVal);
      });
      $("#imgHover" + ind).hover(function() {
          $("#span" + ind).html(obj.val());
      }).mouseout(function() {
          $("#span" + ind).html(maskedVal);
      });
  }
//Attachments
</script>
<body>
<div id="popup_wrap" class="popup_wrap">
  <header class="pop_header">
    <h1>Auto Debit Approval</h1>
    <ul class="right_opt">
      <li><p class="btn_blue2"><a id="btnLedger1" href="#"><spring:message code="sal.btn.ledger" />(1)</a></p></li>
      <li><p class="btn_blue2"><a id="btnLedger2" href="#"><spring:message code="sal.btn.ledger" />(2)</a></p></li>
      <li><p class="btn_blue2"><a id="btnAutoDebitDetailClose" href="#"><spring:message code="sal.btn.close" /></a></p></li>
    </ul>
  </header><!-- pop_header end -->
  <!-- pop_body start -->
  <section class="pop_body">
    <form id="frmLedger" name="frmLedger" action="#" method="post">
      <input id="ordId" name="ordId" type="hidden" value="${mobileAutoDebitDetail.salesOrdId}"/>
    </form>
    <section>
      <table class="type1"><!-- table start -->
        <colgroup>
            <col style="width:180px" />
            <col style="width:*" />
            <col style="width:180px" />
            <col style="width:*" />
        </colgroup>
        <tbody>
          <tr>
            <th scope="row">Pre Auto Debit No</th>
            <td>
              <input type="text" id="preAutoDebitNo" class="readonly w100p" readonly style="display:none"/>
              <span id="spanPreAutoDebitNo" name="spanPreAutoDebitNo"></span>
            </td>
            <th scope="row">PAD Key-in Date</th>
            <td>
              <input type="text" id="padKeyInDate" class="readonly w100p" readonly style="display:none"/>
              <span id="spanPadKeyInDate" name="spanPadKeyInDate"></span>
            </td>
          </tr>
          <tr>
            <th scope="row">Order No</th>
            <td>
              <input type="text" id="orderNumber" class="readonly w100p" readonly style="display:none"/>
              <span id="spanOrderNumber" name="spanOrderNumber"></span>
            </td>
            <th scope="row">Order Date</th>
            <td>
              <input type="text" id="orderDate" class="readonly w100p" readonly style="display:none"/>
              <span id="spanOrderDate" name="spanOrderDate"></span>
            </td>
          </tr>
          <tr>
            <th scope="row">Customer Type</th>
            <td>
              <input type="text" id="custType" class="readonly w100p" readonly style="display:none"/>
              <span id="spanCustType" name="spanCustType"></span>
            </td>
            <th scope="row">Product</th>
            <td>
              <input type="text" id="productName" class="readonly w100p" readonly style="display:none"/>
              <span id="spanProductName" name="spanProductName"></span>
            </td>
          </tr>
          <tr>
            <th scope="row">Customer Name</th>
            <td>
              <input type="text" id="customerName" class="readonly w100p" readonly style="display:none"/>
              <span id="spanCustomerName" name="spanCustomerName"></span>
            </td>
            <th scope="row">Final Rental Fee</th>
            <td>
              <input type="text" id="monthlyRentalFee" class="readonly w100p" readonly style="display:none"/>
              <span id="spanMonthlyRentalFee" name="spanMonthlyRentalFee"></span>
            </td>
          </tr>
          <tr>
            <th scope="row">NRIC/Company No</th>
            <td>
              <input type="text" id="nricCompanyNumber" class="readonly w100p" readonly style="display:none"/>
              <table id="pCompanyNumber" style="display:none">
                <tr>
                  <td width="5%">
                    <a href="#" class="search_btn" id="imgHoverCompanyNumber">
                      <img style="height:70%" src="${pageContext.request.contextPath}/resources/images/common/nricEye2.png" />
                     </a>
                   </td>
                   <td><span id="spanCompanyNumber"></span></td>
                 </tr>
               </table>
            </td>
            <th scope="row">Rental Status</th>
            <td>
              <input type="text" id="rentalStatus" class="readonly w100p" readonly style="display:none"/>
              <span id="spanRentalStatus" name="spanRentalStatus"></span>
            </td>
          </tr>
        </tbody>
      </table>
    </section>

    <!-- tab -->
    <section class="tap_wrap">
      <ul class="tap_type1 num4">
        <li><a id="aTabPI" href="#" class="on">Payment Info</a></li>
        <li><a id="aTabAttach" href="#" class="">Attachment</a></li>
        <li><a id="aTabUS" href="#" class="">Update Status</a></li>
      </ul>
      <!-- Payment Info Tab -->
      <%@ include file="/WEB-INF/jsp/payment/mobileautodebit/autoDebitPaymentInfoTabPop.jsp" %>
      <!-- Attachment Info Tab -->
      <%@ include file="/WEB-INF/jsp/payment/mobileautodebit/autoDebitAttachmentTabPop.jsp" %>
      <!-- Status Info Tab -->
      <%@ include file="/WEB-INF/jsp/payment/mobileautodebit/autoDebitUpdateStatusTabPop.jsp" %>
    </section>
    <c:if test="${authFuncChange == 'Y'}">
    <ul class="center_btns mt20">
        <li><p class="btn_blue2 big"><a id="btnSave" href="#" onclick="saveDataValidation()">Save</a></p></li>
    </ul>
    </c:if>
  </section>
  <!-- pop_body end -->
</div>
</body>