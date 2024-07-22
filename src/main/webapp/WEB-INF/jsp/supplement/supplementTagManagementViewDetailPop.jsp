<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javascript">
  //생성 후 반환 ID
  var purchaseGridID;
  var serialTempGridID;
  var memGridID;
  var paymentGridID;
  var myFileCaches = {};
  var atchFileGrpId = 0;

  var gridID1;
  function tagRespondGrid() {
    var columnLayout1 = [
        {
          headerText : '<spring:message code="service.grid.mainDept" />',
          dataField : "mainDept"
        },
        {
          headerText : '<spring:message code="service.grid.subDept" />',
          dataField : "subDept",
          width : 120
        },
        {
          headerText : '<spring:message code="pay.head.remark" />',
          dataField : "tagRemark",
          width : 220
        },
        {
          headerText : '<spring:message code="supplement.text.supplementTagStus" />',
          dataField : "tagStus",
          width : 120
        },
        {
          headerText : '<spring:message code="service.grid.asEntCreator" />',
          dataField : "callCrtUser",
          width : 120
        },
        {
          headerText : '<spring:message code="service.grid.registerDt" />',
          dataField : "callCrtDt",
          width : 120
        } ];

    var gridPros1 = {
      pageRowCount : 20,
      showStateColumn : false,
      displayTreeOpen : false,
      skipReadonlyColumns : true,
      wrapSelectionMove : true,
      showRowNumColumn : true,
      editable : false,
      wordWrap : true
    };

    gridID1 = GridCommon.createAUIGrid("respond_grid_wrap", columnLayout1, "", gridPros1);
  }

  $(document).ready( function() {
    tagRespondGrid();

    $("#btnLedger").click( function() {
      Common.popupDiv("/supplement/orderLedgerViewPop.do", '', null, true, '_insDiv');
    });

    var attachList = $("#atchFileGrpId").val();
    if (attachList > 0) {
      Common.ajax("GET", "/supplement/selectAttachListCareline.do", { atchFileGrpId : attachList },
        function(result) {
          if (result) {
            if (result.length > 0) {
              $("#attachTd").html("");
              for (var i = 0; i < result.length; i++) {
                var atchTdId = "atchId" + (i + 1);
                $("#attachTd").append("<div class='auto_file2 auto_file3'><input type='text' class='input_text' readonly='readonly' name='" + atchTdId + "'/></div>");
                $(".input_text[name='" + atchTdId + "']").val(result[i].atchFileName);
              }

              $(".input_text").dblclick( function() {
                var oriFileName = $(this).val();
                var fileGrpId;
                var fileId;
                for (var i = 0; i < result.length; i++) {
                  if (result[i].atchFileName == oriFileName) {
                    fileGrpId = result[i].atchFileGrpId;
                    fileId = result[i].atchFileId;
                   }
                 }

                 fn_atchViewDown( fileGrpId, fileId);
               });
             }
           }
      });
    }

    var attachList2 = $("#atchFileGrpIdHQ").val();
    if (attachList2 > 0) {
      Common.ajax("GET", "/supplement/selectAttachListHq.do", { atchFileGrpId : attachList2 },
        function(result) {
          if (result) {
            if (result.length > 0) {
              $("#attachTd").html("");
              for (var i = 0; i < result.length; i++) {
                var atchTdId = "atchId2" + (i + 1);
                $("#attachTd2").append("<div class='auto_file2 auto_file3'><input type='text' class='input_text' readonly='readonly' name='" + atchTdId + "'/></div>");
                $(".input_text[name='" + atchTdId + "']").val(result[i].atchFileName);
              }

              $(".input_text").dblclick(
                function() {
                  var oriFileName = $(this).val();
                  var fileGrpId;
                  var fileId;

                  for (var i = 0; i < result.length; i++) {
                    if (result[i].atchFileName == oriFileName) {
                      fileGrpId = result[i].atchFileGrpId;
                      fileId = result[i].atchFileId;
                    }
                  }
                  fn_atchViewDown(fileGrpId, fileId);
                });
            }
          }
      });
    }

    function fn_atchViewDown(fileGrpId, fileId) {
      if (typeof fileGrpId == 'undefined') {
        return;
      }

      var data = { atchFileGrpId : fileGrpId, atchFileId : fileId };

      Common.ajax("GET", "/eAccounting/webInvoice/getAttachmentInfo.do", data,
        function(result) {
          if (result == null) {
            return;
          }

          var fileSubPath = result.fileSubPath;
          fileSubPath = fileSubPath.replace('\', ' / '');
          window.open("/file/fileDownWeb.do?subPath=" + fileSubPath + "&fileName=" + result.physiclFileName + "&orignlFileNm=" + result.atchFileName);
      });
    }

    $("#respondInfo").click(function() {
      var counselingNum = $("#counselingNo").text();
      Common.ajax("GET", "/supplement/getResponseLst", { supRefId : '${orderInfo.supRefId}', counselingNo : '${tagInfo.counselingNo}' },
        function(result) {
          AUIGrid.setGridData(gridID1, result);
          AUIGrid.resize(gridID1, 900, 300);
      });
    });

    $("#_saveBtn").click(
      function() {
        var inchgDeptList = $("#inchgDeptList").val();
        var ddlSubDeptUpd = $("#ddlSubDeptUpd").val();
        var tagStus = $("#tagStusPop").val();
        var attachment = $("#attch").val().trim();
        var remark = $("#_remark").val().trim();
        var counselingNo = $("#_infoCounselingNo").val();
        var ccr0006dCallEntryIdSeq = $("#_infoCcr0006dCallEntryIdSeq").val();
        var attchFilePathName = "attchFilePathName";
        var preTagStatus = $("#_infoTagStatus").val();
        var preTagStatusId = $("#_infoTagStatusId").val();
        var subTopicId = $("#_infoSubTopicId").val();
        var subTopic = $("#_infoSubTopic").val();

        var supRefId = $("#_infoSupRefId").val();
        var supRefNo = $("#_infoSupRefNo").val();
        var supTagId = $("#_infoSupTagId").val();

        if (!fn_validInpuInfo()) {
          return false;
        }

        if (FormUtil.isNotEmpty($('#attch').val().trim())) {
          var formData = new FormData();
          $.each(myFileCaches, function(n, v) {
            formData.append(n, v.file);
            formData.append(attchFilePathName, "tagApproval");
          });

          var orderVO = {
            supRefId : $("#_infoSupRefId").val(),
            mainDept : $('#inchgDeptList').val().trim(),
            subDept : $('#ddlSubDept').val(),
            callRemark : $('#_remark').val().trim(),
            atchFileGrpId : atchFileGrpId,
            attchFilePathName : "attchFilePathName"
          };

           if (!fn_validFile()) {
             return false;
           }

           Common.ajaxFile("/supplement/attachFileUploadId.do", formData,
             function(result) {
               var param = { supRefId : supRefId,
                                    supRefNo : supRefNo,
                                    mainDept : inchgDeptList,
                                    subDept : ddlSubDeptUpd,
                                    tagStus : tagStus,
                                    remark : remark,
                                    counselingNo : counselingNo,
                                    ccr0006dCallEntryIdSeq : ccr0006dCallEntryIdSeq,
                                    preTagStatusId : preTagStatusId,
                                    subTopicId : subTopicId,
                                    supTagId : supTagId,
                                    attachYN : "Y"
                                  };

               if (result != 0 && result.code == 00) {
                 param["atchFileGrpId"] = result.data.fileGroupKey;
               } else {
                 Common.alert('Save Tag Approval' + DEFAULT_DELIMITER + result.message);
               }

               Common.ajax("POST", "/supplement/updateTagInfo.do", param,
                 function(result) {
                   if (result.code == "00") {
                     Common.alert(" The Tag No. for " + supRefNo + " has been update successfully.", fn_popClose());
                   } else {
                     Common.alert(result.message, fn_popClose);
                   }
               });
             },
             function(result) {
               Common.alert("Upload Failed. Please check with System Administrator.");
             });
           } else {
             var param = { supRefId : supRefId,
                                  supRefNo : supRefNo,
                                  mainDept : inchgDeptList,
                                  subDept : ddlSubDeptUpd,
                                  tagStus : tagStus,
                                  remark : remark,
                                  counselingNo : counselingNo,
                                  ccr0006dCallEntryIdSeq : ccr0006dCallEntryIdSeq,
                                  preTagStatusId : preTagStatusId,
                                  subTopicId : subTopicId,
                                  supTagId : supTagId,
                                  attachYN : "N"
             };

             Common.ajax("POST", "/supplement/updateTagInfo.do", param,
               function(result) {
                 if (result.code == "00") {
                   Common.alert(" The Tag No. for " + supRefNo + " has been update successfully.", fn_popClose());
                 } else {
                   Common.alert(result.message, fn_popClose);
                 }
             });
           }
         });

    fn_inchgDept_SelectedIndexChanged();
  });

  $('#attch').change(function(evt) {
    handleFileChange(evt, 1);
  });

  function fn_validFile() {
    var isValid = true, msg = "";

    if (FormUtil.isEmpty($('#attch').val().trim())) {
      isValid = false;
      msg += 'Attachment is required.';
    }

    $.each(myFileCaches,
      function(i, j) {
        if (myFileCaches[i].file.checkFileValid == false) {
          isValid = false;
          msg += myFileCaches[i].file.name + '<spring:message code="supplement.alert.fileUploadFormat" />';
        }
      });

      if (!isValid)
        Common.alert('Save New Tag Submission' + DEFAULT_DELIMITER + "<b>" + msg + "</b>");
         return isValid;
  }


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

    if (file && file.size > 2000000) {
      msg += "*Only allow .zip file with less than 2MB.<br>";
    }

    if (msg) {
      myFileCaches[cacheIndex].file['checkFileValid'] = false;
      Common.alert(msg);
    } else {
      myFileCaches[cacheIndex].file['checkFileValid'] = true;
    }
  }

  function fn_validFile() {
    var isValid = true, msg = "";

    if (FormUtil.isEmpty($('#attch').val().trim())) {
      isValid = false;
      msg += 'Attachment is required.';
    }

    $.each(myFileCaches,
      function(i, j) {
        if (myFileCaches[i].file.checkFileValid == false) {
          isValid = false;
          msg += myFileCaches[i].file.name + '<spring:message code="supplement.alert.fileUploadFormat" />';
        }
      });

      if (!isValid)
        Common.alert('Save New Tag Submission' + DEFAULT_DELIMITER + "<b>" + msg + "</b>");
        return isValid;
  }

  function fn_popClose() {
    myFileCaches = {};
    fn_getTagMngmtListAjax();
    $("#_systemClose").click();
  }

  function fn_bookingAndpopClose() {
    $("#_systemClose").click();
  }

  function fn_validInpuInfo() {
    var isValid = true, msg = "";

    if (null == $("#inchgDeptList").val() || '' == $("#inchgDeptList").val()) {
      isValid = false;
      msg += 'InCharge Department is required.';
    }

    else if (null == $("#ddlSubDeptUpd").val() || '' == $("#ddlSubDeptUpd").val()) {
      isValid = false;
      msg += 'Sub Department is required.';
    } else if (null == $("#tagStusPop").val() || '' == $("#tagStusPop").val()) {
      isValid = false;
      msg += 'Tag Status is required.';
    }

    if ("10" == $("#tagStusPop").val()) {
      if (null == $("#_remark").val() || '' == $("#_remark").val()) {
        isValid = false;
        msg += 'Remark is required.';
      }
    }

    if (!isValid)
      Common.alert('Update Tag Submission' + DEFAULT_DELIMITER + "<b>" + msg + "</b>");
      return isValid;
  }

  function fn_removeFile(name) {
    if (name == "attch") {
      $("#attch").val("");
      $('#attch').change();
    }
  }

  function fn_inchgDept_SelectedIndexChanged() {
    $("#ddlSubDeptUpd option").remove();
    doGetCombo('/supplement/getSubDeptList.do?DEFECT_GRP_DEPT=' + $("#inchgDeptList").val(), '', '', 'ddlSubDeptUpd', 'S', 'fn_callbackSubDept2');
  }

  function fn_callbackSubDept2() {
    $("#ddlSubDeptUpd").val('SD1003'); // DEFAULT FOOD SUPPLEMENT
  }
</script>

<div id="popup_wrap" class="popup_wrap">
  <input type="hidden" id="_infoParcelTrackNo" value="${orderInfo.parcelTrackNo}">
  <input type="hidden" id="_infoSupRefStus" value="${orderInfo.supRefStusId}">
  <input type="hidden" id="_infoSupRefStg" value="${orderInfo.supRefStgId}">
  <input type="hidden" id="_infoSupRefId" value="${orderInfo.supRefId}">
  <input type="hidden" id="_infoSupRefNo" value="${orderInfo.supRefNo}">
  <input type="hidden" id="_infoCustName" value="${orderInfo.custName}">
  <input type="hidden" id="_infoCustEmail" value="${orderInfo.custEmail}">
  <input type="hidden" id="_infoCounselingNo" value="${tagInfo.counselingNo}">
  <input type="hidden" id="_infoTagStatus" value="${tagInfo.tagStatus}">
  <input type="hidden" id="_infoTagStatusId" value="${tagInfo.tagStatusId}">
  <input type="hidden" id="_infoSubTopicId" value="${tagInfo.subTopicId}">
  <input type="hidden" id="_infoSubTopic" value="${tagInfo.subTopic}">
  <input type="hidden" id="_infoSupTagId" value="${tagInfo.supTagId}">
  <input type="hidden" id="_infoCcr0006dCallEntryIdSeq" value="${tagInfo.ccr0006dCallEntryIdSeq}">

  <header class="pop_header">
    <h1><spring:message code="supplement.title.supplementTagManagement" /> - <spring:message code="pay.btn.approval" /></h1>
    <ul class="right_opt">
      <li>
        <p class="btn_blue2">
          <a id="_systemClose"><spring:message code="sal.btn.close" /></a>
        </p>
      </li>
    </ul>
  </header>
  <section class="pop_body">
    <section class="tap_wrap">
      <ul class="tap_type1">
        <li><a href="#" class="on"><spring:message code='service.title.tInfo' /></a></li>
        <li><a href="#" id="respondInfo"><spring:message code='service.title.respInfo' /></a></li>
        <li><a href="#" id="orderInfo"><spring:message code='sales.tap.order' /></a></li>
      </ul>
      <article class="tap_area">
        <section class="tap_wrap mt0">
          <article class="tap_area">
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
                  <th scope="row"><spring:message code="supplement.text.tagNo" /></th>
                  <td><span>${tagInfo.counselingNo}</span></td>
                  <th scope="row"><spring:message code="service.title.inqCustNm" /></th>
                  <td><span>${tagInfo.custName}</span></td>
                  <!-- <th scope="row"><spring:message code="service.title.inqMemTyp" /></th>
                  <td><span>Customer</span></td> -->
                </tr>
                <tr>
                  <th scope="row"><spring:message code="service.title.initMainDept" /></th>
                  <td>${tagInfo.inchgDeptName}</td>
                  <th scope="row"><spring:message code="service.title.initSubDept" /></th>
                  <td>${tagInfo.subDeptName}</td>
                </tr>

                <tr>
                  <th scope="row"><spring:message code="supplement.text.supplementReferenceNo" /></th>
                  <td>${tagInfo.supRefNo}</td>
                  <th scope="row"><spring:message code="service.title.CustomerID" /></th>
                  <td>${tagInfo.custId}</td>
                </tr>

                <tr>
                  <th scope="row"><spring:message code="supplement.text.supplementTagRegisterDt" /></th>
                  <td>${tagInfo.tagRegisterDt}</td>
                  <th scope="row"><spring:message code="supplement.text.supplementTagStus" /></th>
                  <td>${tagInfo.tagStatus}</td>
                </tr>
                <tr>
                  <th scope="row"><spring:message code="service.text.InChrDept" /></th>
                  <td>${tagInfo.inchgDeptName}</td>
                  <th scope="row"><spring:message code="service.grid.subDept" /></th>
                  <td>${tagInfo.subDeptName}</td>
                </tr>
                <tr>
                  <th scope="row"><spring:message code="supplement.text.supplementMainTopicInquiry" /></th>
                  <td>${tagInfo.mainTopic}</td>
                  <th scope="row"><spring:message code="supplement.text.supplementSubTopicInquiry" /></th>
                  <td>${tagInfo.subTopic}</td>
                </tr>
                <tr>
                  <td colspan="4"></td>
                </tr>
                <tr>
                  <th scope="row"><spring:message code="service.title.carelineAttc" /></th>
                  <td colspan="3" id="attachTd"><input type="hidden" id="atchFileGrpId" value="${tagInfo.supTagFlAttId1}">
                  </td>
                </tr>
                <tr>
                  <th scope="row"><spring:message code="service.title.hqAttc" /></th>
                  <td colspan="3" id="attachTd2"><input type="hidden" id="atchFileGrpIdHQ" value="${tagInfo.supTagFlAttId2 }">
                  </td>
                </tr>
              </tbody>
              </br>
            </table>
          </article>
        </section>
      </article>
      <article class="tap_area">
        <aside class="title_line">
          <h3>
            <spring:message code='service.title.respInfo' />
          </h3>
        </aside>
        <article class="grid_wrap">
          <div id="respond_grid_wrap"
            style="width: 100%; height: 300px; margin: 0"></div>
        </article>
      </article>
      <article class="tap_area">
        <aside class="title_line">
          <h3>Order Information</h3>
          <ul class="right_opt">
          </ul>
        </aside>
        <!------------------------------------------------------------------------------
          Order Detail Page Include START
         ------------------------------------------------------------------------------->
        <%@ include
          file="/WEB-INF/jsp/supplement/supplementDetailContent.jsp"%>
        <!------------------------------------------------------------------------------
          Order Detail Page Include END
         ------------------------------------------------------------------------------->
      </article>
    </section>
  </section>
</div>