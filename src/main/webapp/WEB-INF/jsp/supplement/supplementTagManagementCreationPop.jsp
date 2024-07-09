<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javascript">
  var purchaseGridID;
  var serialTempGridID;
  var memGridID;
  var paymentGridID;
  var myFileCaches = {};
  var atchFileGrpId = 0;

  function setInputFile2(){//인풋파일 세팅하기
        $(".auto_file").append("<label><input type='text' class='input_text' readonly='readonly' /><span class='label_text'><a href='#'>File</a></span></label>");
    }

  $(document).ready(function() {
    if ('${orderInfo}' != "" && '${orderInfo}' != null) {
      $("#basicForm").show();
      $("#inputForm").show();
      $("#btnLedger").show();
      $('#entry_supRefNo').val('${orderInfo.supRefNo}');
    }

    $('#btnLedger').click(function() {
      Common.popupWin("frmLedger", "/supplement/orderLedgerViewPop.do", {width : "1000px", height : "720", resizable: "no", scrollbars: "no"});
    });

    setTimeout(function() {
      fn_descCheck(0)
    }, 1000);

    setInputFile2();
  });

  $('#attch').change(function(evt) {
      handleFileChange(evt, 1);
  });

  // Define a common function to handle file input changes
  function handleFileChange(evt, cacheIndex) {
      var file = evt.target.files[0];
      if (file == null && myFileCaches[cacheIndex] != null) {
          delete myFileCaches[cacheIndex];
      } else if (file != null) {
          myFileCaches[cacheIndex] = {
              file : file
          };
      }

      var msg = '';
      if (file && file.name.length > 30) {
          msg += "*File name wording should be not more than 30 alphabet.<br>";
      }

/*       var fileType = file ? file.type.split('/') : [];
      if (fileType[1] != 'jpg' && fileType[1] != 'jpeg' && fileType[1] != 'png' && fileType[1] != 'pdf') {
          msg += "*Only allow picture format (JPG, PNG, JPEG, PDF).<br>";
      } */

      if (file && file.size > 2000000) {
          msg += "*Only allow .zip file with less than 2MB.<br>";
      }

      if (msg) {
          myFileCaches[cacheIndex].file['checkFileValid'] = false;
          Common.alert(msg);
      } else {
          myFileCaches[cacheIndex].file['checkFileValid'] = true;
      }

      //console.log("myFileCaches::" + myFileCaches);
  }

  $('#_saveBtn').click(function() {

      if (!fn_validInpuInfo()) {
          return false;
      }

        fn_SaveTagSubmission();
    });

  function fn_validInpuInfo() {
      var isValid = true, msg = "";

      if(null == $("#mainTopicList").val() || '' == $("#mainTopicList").val()){
          isValid = false;
          msg += 'Main Topic Inquiry is required.';
      }

      else if( null == $("#ddlSubTopic").val() || '' == $("#ddlSubTopic").val()){
          isValid = false;
          msg += 'Sub Topic Inquiry is required.';
      }

      else if( null == $("#inchgDeptList").val() || '' == $("#inchgDeptList").val()){
          isValid = false;
          msg += 'Incharge Department is required.';
      }

      else if( null == $("#ddlSubDept").val() || '' == $("#ddlSubDept").val()){
          isValid = false;
          msg += 'Sub Department is required.';
      }

      if (!isValid)Common.alert('Save New Tag Submission'+ DEFAULT_DELIMITER + "<b>" + msg + "</b>");

      return isValid;
  }

  function fn_validFile() {
      var isValid = true, msg = "";

      if (FormUtil.isEmpty($('#attch').val().trim())) {
          isValid = false;
          msg += 'Attachment is required.';
      }

      $.each(myFileCaches,function(i, j) {
                          if (myFileCaches[i].file.checkFileValid == false) {
                              isValid = false;
                              msg += myFileCaches[i].file.name + '<spring:message code="supplement.alert.fileUploadFormat" />';
                          }
                      });

      if (!isValid)
          Common.alert('Save New Tag Submission'+ DEFAULT_DELIMITER + "<b>" + msg + "</b>");

      return isValid;
  }

  function fn_formSetting() {
    $("#basicForm").show();
    $("#inputForm").show();
  }

  function fn_popClose() {
    $("#_systemClose").click();
  }

  function fn_descCheck(ind) {
    var indicator = ind;
    var jsonObj = {
      DEFECT_GRP : $("#mainTopicList").val(),
      DEFECT_GRP_DEPT : $("#inchgDeptList").val(),
      TYPE : "SMI"
    };

    doGetCombo('/supplement/getSubTopicList.do?DEFECT_GRP=' + $("#mainTopicList").val(), '', '', 'ddlSubTopic', 'S', '');
    doGetCombo('/supplement/getSubDeptList.do?DEFECT_GRP_DEPT=' + $("#inchgDeptList").val(), '', '', 'ddlSubDept', 'S', '');
  }

  function fn_mainTopic_SelectedIndexChanged() {
    $("#ddlSubTopic option").remove();
    doGetCombo('/supplement/getSubTopicList.do?DEFECT_GRP=' + $("#mainTopicList").val(), '', '', 'ddlSubTopic', 'S', '');
  }

  function fn_inchgDept_SelectedIndexChanged() {
    $("#ddlSubDept option").remove();
    doGetCombo('/supplement/getSubDeptList.do?DEFECT_GRP_DEPT=' + $("#inchgDeptList").val(), '', '', 'ddlSubDept', 'S', '');
  }

   function fn_checkOrderNo() {
    if ($("#entry_supRefNo").val() == "") {
      var field = "<spring:message code='supplement.text.supplementReferenceNo' />";
      Common.alert("<spring:message code='sys.msg.necessary' arguments='* <b>" + field + "</b>' htmlEscape='false'/>");
      return;
    }

    Common.ajax("GET", "/supplement/searchOrderNo", { orderNo : $("#entry_supRefNo").val() }, function(result) {
        console.log("result.supRefId:: " +result.supRefId);
      if (result == null) {
        var field = "<spring:message code='supplement.text.supplementReferenceNo' />";
        Common.alert("<spring:message code='sys.msg.notexist' arguments='* <b>" + $("#entry_supRefNo").val() + "</b>' htmlEscape='false'/>");
        return;
      } else {
        Common.popupDiv("/supplement/supplementViewBasicPop.do", {
          supRefNo : $("#entry_supRefNo").val()
        }, fn_formSetting(), true, '_insDiv2');

        $("#_systemClose").click();
      }
    });
  }

  function fn_goOrdSearch(){
    Common.popupDiv('/supplement/searchOrdNoPop.do', null, null, true, '_searchDiv');
  }

//TODO 미개발 message

  function fn_SaveTagSubmission(){

      var orderVO = {

              supRefId :  $("#_infoSupRefId").val(),
              mainTopic : $('#mainTopicList').val().trim(),
              subTopic : $('#ddlSubTopic').val().trim(),
              mainDept : $('#inchgDeptList').val().trim(),
              subDept : $('#ddlSubDept').val().trim(),
              callRemark : $('#_remark').val().trim(),
              atchFileGrpId : atchFileGrpId,
              attchFilePathName : "attchFilePathName"

      };

      var supRefId =  $("#_infoSupRefId").val();
      var subTopic = $('#ddlSubTopic').val().trim();
      var supRefStus = $("#_infoSupRefStus").val();
      var supRefStusId = $("#_infoSupRefStusId").val();
      var attchFilePathName = "attchFilePathName";


      var formData = new FormData();
      $.each(myFileCaches, function(n, v) {
        //console.log("n : " + n + " v.file : " + v.file);
        formData.append(n, v.file);
        formData.append(attchFilePathName, "tagSubmission");
      });

      console.log("supRefId###::" + supRefId);
      console.log("subTopic###::" + subTopic);
      console.log("supRefStus###::" + supRefStus);
      console.log("supRefStusId###::" + supRefStusId);


              if (subTopic ==  "4001") { // Request Refund
                  if (supRefStusId !=  "1"){ // need change to (supRefStusId !=  "4")
                      Common.alert("Process failed. Please check the Supplement Reference Status.");
                      return false;
                  } else {
                      if (!fn_validFile()) {
                             return false;
                         }
                  }
              }

              console.log("Attachment value::" + $("#attch").val());


             if($("#attch").val().trim() !=""){

              Common.ajaxFile("/supplement/attachFileUploadId.do", formData, function(result) {

                  //console.log("result attachFileUploadId:: " + result.code);

                    if (result != 0 && result.code == 00) {
                        orderVO["atchFileGrpId"] = result.data.fileGroupKey;

                      } else {
                        Common.alert('Save New Tag Submission'+ DEFAULT_DELIMITER + result.message);
                      }

                       Common.ajax("POST","/supplement/supplementTagSubmission.do", orderVO,
                              function(result) {Common.alert( 'Save New Tag Submission'
                                            + DEFAULT_DELIMITER
                                            + "<b>"
                                            + result.message
                                            + "</b>",
                                            fn_closeSupplementSubmissionPop);
                              });
              },

                  function(result) {
                    Common.alert("Upload Failed. Please check with System Administrator.");
                  });
             }

             else {

                 Common.ajax("POST","/supplement/supplementTagSubmission.do", orderVO,
                         function(result) {Common.alert( 'Save New Tag Submission'
                                       + DEFAULT_DELIMITER
                                       + "<b>"
                                       + result.message
                                       + "</b>",
                                       fn_closeSupplementSubmissionPop);
                         });

             }

  }


  function fn_closeSupplementSubmissionPop() {
      myFileCaches = {};
      $('#_systemClose').click();
    }

  function fn_removeFile(name){
    if(name == "attch") {
       $("#attch").val("");
       $('#attch').change();
    }
  }

    function fn_callbackOrdSearchFunciton(ordNo) {
    $("#entry_supRefNo").val(ordNo);
    fn_checkOrderNo();
  }
</script>
<div id="popup_wrap" class="popup_wrap">

<input type="hidden" id="_infoSupRefId" value="${orderInfo.supRefId}">
<input type="hidden" id="_infoSupRefStus" value="${orderInfo.supRefStus}">
<input type="hidden" id="_infoSupRefStusId" value="${orderInfo.supRefStusId}">

  <header class="pop_header">
    <h1>Tag Management - New Ticket</h1>
    <ul class="right_opt">
      <li>
        <p class="btn_blue2" style="display:none" id="btnLedger">
          <a id="btnLedger" href="#"><spring:message code="sal.btn.ledger" /></a>
        </p>
      </li>
      <li>
        <p class="btn_blue2">
          <a id="_systemClose" href="#" ><spring:message code="sal.btn.close" /></a>
        </p>
      </li>
    </ul>
  </header>
  <section class="pop_body">
    <form id="frmLedger" name="frmLedger" action="#" method="post">
      <input id="supRefId" name="supRefId" type="hidden" value="${orderInfo.supRefId}" />
    </form>
    </br>
    <table class="type1">
      <caption>table</caption>
      <colgroup>
        <col style="width: 180px" />
        <col style="width: *" />
      </colgroup>
      <tbody>
        <tr>
          <th scope="row"><spring:message code='supplement.text.supplementReferenceNo' /><span class="must">*</span></th>
          <td>
            <input type="text" title="" placeholder="Order No." class="" id="entry_supRefNo" name="entry_supRefNo" />
            <p class="btn_sky">
              <a href="#" onClick="fn_checkOrderNo()"><spring:message code='pay.combo.confirm' /></a>
            </p>
            <p class="btn_sky">
              <a href="#" onclick="fn_goOrdSearch()"><spring:message code='sys.btn.search' /></a>
            </p>
          </td>
        </tr>
      </tbody>
    </table>
    </br>

    <section class="tap_wrap">
      <form id="basicForm" style="display: none">
        <!------------------------------------------------------------------------------
          Supplement Detail Page Include START
         ------------------------------------------------------------------------------->
        <%@ include
          file="/WEB-INF/jsp/supplement/supplementDetailContent.jsp"%>
        <!------------------------------------------------------------------------------
          Supplement Detail Page Include END
          ------------------------------------------------------------------------------->
      </form>
    </section>
    </br>
    </br>
    <form id="inputForm" style="display:none ">
      <aside class="title_line">
        <h2><spring:message code='supplement.text.generalInfo' /></h2>
      </aside>
      <table class="type1">
        <caption>table</caption>
        <colgroup>
          <col style="width: 180px" />
          <col style="width: *" />
          <col style="width: 180px" />
          <col style="width: *" />
        </colgroup>
        <tbody>
          <tr>
            <th scope="row"><spring:message code="supplement.text.supplementMainTopicInquiry" /><span class="must">*</span></th>
            <td>
              <select class="select w100p" id="mainTopicList" name="mainTopicList" onChange="fn_mainTopic_SelectedIndexChanged()">
                <option value="">Choose One</option>
                <c:forEach var="list" items="${mainTopic}" varStatus="status">
                  <option value="${list.codeId}">${list.codeName}</option>
                </c:forEach>
              </select>
            </td>
            <th scope="row"><spring:message code="supplement.text.supplementSubTopicInquiry" /><span class="must">*</span></th>
            <td>
              <select id='ddlSubTopic' name='ddlSubTopic' class="w100p"></select>
            </td>
          </tr>
          <tr>
            <th scope="row"><spring:message code="service.text.InChrDept" /><span class="must">*</span></th>
            <td>
              <select class="select w100p" id="inchgDeptList" name="inchgDeptList" onChange="fn_inchgDept_SelectedIndexChanged()">
                <option value="">Choose One</option>
                <c:forEach var="list" items="${inchgDept}" varStatus="status">
                  <option value="${list.codeId}">${list.codeName}</option>
                </c:forEach>
              </select>
            </td>
            <th scope="row"><spring:message code="service.grid.subDept" /><span class="must">*</span></th>
            <td><select id='ddlSubDept' name='ddlSubDept' class="w100p"></select>
            </td>
          </tr>

          <tr>
            <th scope="row"><spring:message code='service.text.attachment' /></th>
            <td colspan="3">
              <div class="auto_file2">
                <input type="file" title="" id="attch" accept=".zip" />
                <label>
                  <input type='text' class='input_text' id='labelFileInput' readonly='readonly' />
                  <span class='label_text' id='labelFileInput'><a href='#'><spring:message code='sys.btn.upload' /></a></span>
                </label>
                <span class='label_text'><a href='#' onclick='fn_removeFile("attch")'><spring:message code='sys.btn.remove' /></a></span>
              </div>
            </td>
          </tr>
          <tr>
            <th scope="row"><spring:message code="pay.head.remark" /></th>
            <td colspan="3">
              <input type="text" title="" placeholder="Remark" class="w100p" id="_remark" " name="remark" />
            </td>
          </tr>
        </tbody>
      </table>
      <ul class="center_btns">
        <li>
          <p class="btn_blue2">
            <a id="_saveBtn"><spring:message code="sal.btn.save" /></a>
          </p>
        </li>
      </ul>
    </form>
  </section>
</div>