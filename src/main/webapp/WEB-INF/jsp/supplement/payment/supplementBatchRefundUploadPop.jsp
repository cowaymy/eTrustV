<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">
  var myUploadGridID;

  var gridPros = {
    showStateColumn : false,
    headerHeight : 35,
    softRemoveRowMode : false
  };

  var uploadGridLayout = [ { dataField : "0",
                                         headerText : "<spring:message code='supplement.head.borNo'/>",
                                         editable : true
                                      }, {
                                         dataField : "1",
                                         headerText : "<spring:message code='supplement.head.amount'/>",
                                         editable : true,
                                         dataType : "numeric",
                                         formatString : "#,##0.00"
                                      }, {
                                         dataField : "2",
                                         headerText : "<spring:message code='supplement.head.chqNo'/>",
                                         editable : true
                                      }, {
                                         dataField : "3",
                                         headerText : "<spring:message code='supplement.head.refNo'/>",
                                         editable : true
                                      }, {
                                         dataField : "4",
                                         headerText : "<spring:message code='supplement.text.remark'/>",
                                         editable : true
                                      } ];

  $(document).ready(
    function() {
      setInputFile();

      myUploadGridID = GridCommon.createAUIGrid( "grid_upload_refund_wrap", uploadGridLayout, null, gridPros);
      $("#close_btn").click(fn_closePop);

      CommonCombo.make("pPayMode", "/supplement/payment/selectCodeList.do", null, "108", { id : "code", name : "codeName", type : "S" }, fn_setAccNo);

      fn_setAccNo();

      $('#uploadfile').on( 'change',
        function(evt) {
          var fileInput = this;
          var file = fileInput.files[0];

          if (!file) {
            var msgLabel = "<spring:message code='sal.text.attachment'/>"
            Common.alert("<spring:message code='sys.msg.necessary' arguments='"+ msgLabel +"'/>");
            return;
          }

          var fileType = file.type;
          var fileName = file.name;
          var isCSV = fileName.endsWith('.csv');

          if (!isCSV) {
            Common.alert("<spring:message code='supplement.alert.supplementBatchUploadCsv' />");
            $("#uploadRefundForm")[0].reset();
            AUIGrid.clearGridData(myUploadGridID);
            return;
          }

          if (!checkHTML5Brower()) {
            commitFormSubmit();
          } else {
            var data = null;
            var file = evt.target.files[0];
            if (typeof file == "undefined") {
              return;
            }

            var reader = new FileReader();
            reader.readAsText(file, "EUC-KR");
            reader.onload = function(event) {
            if (typeof event.target.result != "undefined") {
              AUIGrid.setCsvGridData( myUploadGridID, event.target.result, false);
              AUIGrid.removeRow(myUploadGridID, 0);
            } else {
              Common.alert("<spring:message code='pay.alert.noData'/>");
            }
          };

          reader.onerror = function() {
            Common.alert("<spring:message code='pay.alert.unableToRead' arguments='"+file.fileName+"' htmlEscape='false'/>");
          };
        }
      });
  });

  function commitFormSubmit() {
    AUIGrid.showAjaxLoader(myUploadGridID);

    $('#uploadRefundForm').ajaxSubmit({ type : "json",
      success : function(responseText, statusText) {
        if (responseText != "error") {
          var csvText = responseText;
          csvText = csvText.replace(/\r?\n/g, "\r\n");

          AUIGrid.setCsvGridData(myUploadGridID, csvText);
          AUIGrid.removeAjaxLoader(myUploadGridID);
          AUIGrid.removeRow(myUploadGridID, 0);
        }
      },
      error : function(e) {
        Common.alert("ajaxSubmit Error : " + e);
      }
    });
  }

  function checkHTML5Brower() {
    var isCompatible = false;
    if (window.File && window.FileReader && window.FileList && window.Blob) {
      isCompatible = true;
    }

    return isCompatible;
  }

  function uploadClear() {
    if ($("#uploadfile").val() == "" || $("#uploadfile").val() == null) {
      Common.alert('<spring:message code="supplement.alert.noDataRemove" />');
      return;
    }

    $("#uploadRefundForm")[0].reset();
    AUIGrid.clearGridData(myUploadGridID);
    $("#pPayMode").val("108");
  }

  function setInputFile() {
    $(".auto_file").append("<label><span class='label_text'><a href='#'>File</a></span><input type='text' class='input_text' readonly='readonly' /></label>");
  }

  function fn_closePop() {
    $("#bRefundUploadPop").remove();
  }

  function fn_setAccNo() {
    CommonCombo.make("accNo", "/supplement/payment/selectAccNoList.do", { payMode : $("#pPayMode").val() }, "", { id : "codeId", name : "codeName",  type : "S" });
  }

  function fn_uploadFile() {
    var formData = new FormData();
    var payMode = $("#pPayMode option:selected").val();
    var accNo = $("#accNo").val();
    var remark = $("#remark").val();
    var msgLabel = "";

    if (payMode == "") {
      // Common.alert('<spring:message code="pay.alert.selectPayMode"/>');
      msgLabel = "<spring:message code='supplement.head.paymode' />";
      Common.alert("<spring:message code='sys.msg.necessary' arguments='"+ msgLabel +"'/>");
      return;
    }

    if (accNo == "") {
      msgLabel = "<spring:message code='supplement.head.accountNo' />";
      Common.alert("<spring:message code='sys.msg.necessary' arguments='"+ msgLabel +"'/>");
      return;
    }

    if (FormUtil.isEmpty($("#uploadfile").val())) {
      // Common.alert('<spring:message code="pay.alert.selectCsvFile"/>');
      msgLabel = "<spring:message code='service.text.attachment' />";
      Common.alert("<spring:message code='sys.msg.necessary' arguments='"+ msgLabel +"'/>");
      return;
    }

    formData.append("csvFile", $("input[name=uploadfile]")[0].files[0]);
    formData.append("payMode", payMode);
    formData.append("accNo", accNo);
    formData.append("remark", remark);

    Common.ajaxFile("/supplement/payment/bRefundCsvFileUpload.do",
        formData, function(result) {
          $('#pPayMode option[value=""]').attr('selected', 'selected');
          Common.alert(result.message);
          fn_closePop();
          fn_selectBatchRefundList();
    });
  }
</script>

<div id="upload_popup_wrap" class="popup_wrap">
  <header class="pop_header">
    <h1>
      <spring:message code='supplement.title.batchRefundUpload' />
    </h1>
    <ul class="right_opt">
      <li>
        <p class="btn_blue2">
          <a href="${pageContext.request.contextPath}/resources/download/supplement/SupplementBatchRefundFormat.csv"><spring:message code='supplement.btn.downloadTemplate' /></a>
        </p>
      </li>
      <li>
        <p class="btn_blue2">
          <a href="#" id="close_btn"><spring:message code='sys.btn.close' /></a>
        </p>
      </li>
    </ul>
  </header>
  <section class="pop_body">
    <form action="#" method="post" id="uploadRefundForm">
      <table class="type1">
        <caption>table</caption>
        <colgroup>
          <col style="width: 150px" />
          <col style="width: *" />
        </colgroup>
        <tbody>
          <tr>
            <th scope="row"><spring:message code='supplement.head.paymode' /><span class="must">**</span></th>
            <td>
              <select class="" id="pPayMode" name="payMode" onchange="javascript:fn_setAccNo()"></select>
            </td>
          </tr>
          <tr>
            <th scope="row"><spring:message code='supplement.head.accountNo' /><span class="must">**</span></th>
            <td>
              <select class="" id="accNo" name="accNo"></select>
            </td>
          </tr>
          <tr>
            <th scope="row"><spring:message code='supplement.text.remark' /></th>
            <td>
              <textarea class="w100p" rows="4" style="height: auto" id="remark" name="remark"></textarea>
            </td>
          </tr>
          <tr>
            <th scope="row"><spring:message code='service.text.attachment' /><span class="must">**</span></th>
            <td>
              <div class="auto_file">
                <input type="file" title="file add" id="uploadfile" name="uploadfile" accept=".csv" />
              </div>
            </td>
          </tr>
          <tr>
            <td colspan="2">
              <span class="red_text">** <spring:message code="supplement.alert.supplementBatchUploadCsvNotice" /></span>
            </td>
          </tr>
        </tbody>
      </table>
    </form>
    <ul class="center_btns mt20">
      <li>
        <p class="btn_blue2 big">
          <a href="javascript:fn_uploadFile();"><spring:message code='supplement.btn.uploadFile' /></a>
        </p>
      </li>
      <li>
        <p class="btn_blue2 big">
          <a href="javascript:uploadClear();"><spring:message code='supplement.btn.removeFile' /></a>
        </p>
      </li>
    </ul>
    <section class="search_result">
      <article class="grid_wrap">
        <div style="width: 100%; height: 450px; margin: 0 auto;" id="grid_upload_refund_wrap" />
      </article>
    </section>
  </section>
</div>
