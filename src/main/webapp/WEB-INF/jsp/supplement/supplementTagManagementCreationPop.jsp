<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javascript">
  var purchaseGridID;
  var serialTempGridID;
  var memGridID;
  var paymentGridID;

  function setInputFile2(){//인풋파일 세팅하기
	    $(".auto_file").append("<label><input type='text' class='input_text' readonly='readonly' /><span class='label_text'><a href='#'>File</a></span></label>");
	}
	setInputFile2();

  $(document).ready(function() {
    if ('${orderInfo}' != "" && '${orderInfo}' != null) {
      $("#basicForm").show();
      $("#inputForm").show();
      $('#entry_supRefNo').val('${orderInfo.supRefNo}');
    }

    setTimeout(function() {
      fn_descCheck(0)
    }, 1000);
  });

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

  function fn_removeFile(name){
    if(name == "attch") {
       $("#attch").val("");
       $('#attch').change();
    }
  }
</script>
<div id="popup_wrap" class="popup_wrap">
  <header class="pop_header">
    <h1>Tag Management - New Ticket</h1>
    <ul class="right_opt">
      <li>
        <p class="btn_blue2">
          <a id="btnLedger" href="#"><spring:message code="sal.btn.ledger" /></a>
        </p>
      </li>
      <li>
        <p class="btn_blue2">
          <a id="_systemClose"><spring:message code="sal.btn.close" /></a>
        </p>
      </li>
    </ul>
  </header>
  <section class="pop_body">
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
              <a href="#" onclick="fn_goCustSearch()"><spring:message code='sys.btn.search' /></a>
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
                <input type="file" title="" id="attch" accept="image/*" />
                <label>
                  <input type='text' class='input_text' readonly='readonly' />
                  <span class='label_text'><a href='#'><spring:message code='sys.btn.upload' /></a></span>
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