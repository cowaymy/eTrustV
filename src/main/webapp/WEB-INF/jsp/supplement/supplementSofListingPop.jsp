<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">
  var supSofGridID;
  createAUIGrid();

  function fn_multiComboBranch() {
    if ($("#cmbKeyBranch option[value='${ind}']").val() === undefined) {
      $("#cmbKeyBranch").prop('disabled', false);
    } else {
      if ('${auth}' == "Y") {
        $("#cmbKeyBranch").val('${ind}');
        $("#cmbKeyBranch").prop('disabled', false);
      } else {
        $("#cmbKeyBranch").val('${ind}');
        $("#cmbKeyBranch").prop('disabled', true);
      }
    }
  }

  function validRequiredField(){
    var valid = true;
    var message = "";

    var sDate = $('#dpOrderDateFr').val();
    var eDate = $('#dpOrderDateTo').val();

    var dd = "";
    var mm = "";
    var yyyy = "";

    var dateArr;
    dateArr = sDate.split("/");
    var sDt = new Date(Number(dateArr[2]), Number(dateArr[1]) - 1, Number(dateArr[0]));

    dateArr = eDate.split("/");
    var eDt = new Date(Number(dateArr[2]), Number(dateArr[1]) - 1, Number(dateArr[0]));

    var dtDiff = new Date(eDt - sDt);
    var days = dtDiff / 1000 / 60 / 60 / 24;

    if (days > 31) {
      var label = "<spring:message code='sal.text.ordDate' />";
      Common.alert("<spring:message code='service.msg.asSearchDtRange' arguments='" + label + " ; <b>" + 31 +"</b>' htmlEscape='false' argumentSeparator=';' />");
      return false;
    }

    if (($("#dpOrderDateFr").val() == null || $("#dpOrderDateFr").val().length == 0) || ($("#dpOrderDateTo").val() == null || $("#dpOrderDateTo").val().length == 0)){
      valid = false;
      message += '<spring:message code="sal.alert.msg.keyInOrdDateFromTo" />';
    }

    if(!($("#txtOrderNoFr").val().trim() == null || $("#txtOrderNoFr").val().trim().length == 0) || !($("#txtOrderNoTo").val().trim() == null || $("#txtOrderNoTo").val().trim().length == 0)){
      if(($("#txtOrderNoFr").val().trim() == null || $("#txtOrderNoFr").val().trim().length == 0) || ($("#txtOrderNoTo").val().trim() == null || $("#txtOrderNoTo").val().trim().length == 0)){
        valid = false;
        message += '<spring:message code="sal.alert.msg.keyInOrdNoFromTo" />';
      }
    }

    if(valid == false){
      alert(message);
    }

    return valid;
  }

  function fn_search() {
    if (validRequiredField()) {
      var params = {};

      params["dpOrderDateFr"] =$("#dpOrderDateFr").val();
      params["dpOrderDateTo"] =$("#dpOrderDateTo").val();
      params["txtOrderNoFr"] =$("#txtOrderNoFr").val().replace(/[^0-9]/g, '');
      params["txtOrderNoTo"] =$("#txtOrderNoTo").val().replace(/[^0-9]/g, '');
      params["txtCustName"] =$("#txtCustName").val();
      params["cmbKeyBranch"] =$("#cmbKeyBranch").val();
      params["keyInUser"] =$("#txtUserName").val();
      params["cmbSort"] =$("#cmbSort").val();

      Common.ajax("GET", "/supplement/getSofListingInfo.do", params, function(result) {
        AUIGrid.setGridData(supSofGridID, result);
      });
    }
  }

  function createAUIGrid() {
    var sofColumnLayout = [
    {
      dataField : "supRefCrtDt",
      headerText : '<spring:message code="sal.text.createDate" />',
      width : '20%',
      editable : false
    }, {
      dataField : "supRefNo",
      headerText : '<spring:message code="supplement.text.supplementReferenceNo" />',
      width : '20%',
      editable : false
    }, {
      dataField : "sofNo",
      headerText : '<spring:message code="supplement.text.eSOFno" />',
      width : '15%',
      editable : false
    }, {
      dataField : "br",
      headerText : '<spring:message code="sales.keyInBranch" />',
      width : '15%',
      editable : false
    }, {
      dataField : "custName",
      headerText : '<spring:message code="sal.text.custName" />',
      width : '20%',
      style : 'left_style',
      editable : false
    }, {
      dataField : "salesmanId",
      headerText : '<spring:message code="sal.text.salManCode" />',
      width : '15%',
      editable : false
    }, {
      dataField : "salesmanName",
      headerText : '<spring:message code="sal.text.salManName" />',
      width : '20%',
      style : 'left_style',
      editable : false
    }, {
      dataField : "supRefItm",
      headerText : '<spring:message code="sal.text.productItem" />',
      width : '35%',
      editable : false
    }, {
      dataField : "refCreateBy",
      headerText : '<spring:message code="sal.text.createBy" />',
      width : '10%',
      editable : false
    }, {
      dataField : "isCompany",
      headerText :  '<spring:message code="sal.title.custType" />',
      width : '15%',
      editable : false
    }];

    var gridPros = {
      showRowAllCheckBox : false,
      usePaging : true,
      pageRowCount : 10,
      headerHeight : 30,
      showRowNumColumn : true,
      showRowCheckColumn : false,
    };

    supSofGridID = GridCommon.createAUIGrid("#sofList_grid", sofColumnLayout, '', gridPros);
  }

  function excelDown() {
    const today = new Date();
    const day = String(today.getDate()).padStart(2, '0');
    const month = String(today.getMonth() + 1).padStart(2, '0');
    const year = today.getFullYear();

    const date = year + month + day;
    GridCommon.exportTo("sofList_grid", "xlsx", "SOF_Listing_Xlsx_" + date);
  }

  function pdfDown() {
    const today = new Date();
    const day = String(today.getDate()).padStart(2, '0');
    const month = String(today.getMonth() + 1).padStart(2, '0');
    const year = today.getFullYear();

    const date = year + month + day;
    GridCommon.exportTo("sofList_grid", "pdf", "SOF_Listing_Pdf_" + date);
  }

  CommonCombo.make('cmbKeyBranch', '/sales/ccp/getBranchCodeList', '' , '', '', fn_multiComboBranch);
</script>

<div id="popup_wrap" class="popup_wrap">
  <header class="pop_header">
    <h1><spring:message code="sal.title.text.ordReportSalesOrdFromSofList" /></h1>
    <ul class="right_opt">
      <li><p class="btn_blue2"><a href="#" onclick="javascript:fn_search();"><spring:message code="sales.btn.search" /></a></p></li>
      <li><p class="btn_blue2"><a href="#"><spring:message code="sal.btn.close" /></a></p></li>
    </ul>
  </header>

  <section class="pop_body">
    <aside class="title_line"></aside>
  <section class="search_table">
  <form id="searchForm2">
    <table class="type1">
      <caption>table</caption>
      <colgroup>
        <col style="width:180px" />
        <col style="width:*" />
        <col style="width:180px" />
        <col style="width:*" />
      </colgroup>
      <tbody>
        <tr>
          <th scope="row"><spring:message code="sal.text.ordDate" /></th>
          <td>
            <div class="date_set w100p">
              <p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" id="dpOrderDateFr" value="${bfDay}"/></p>
              <span><spring:message code="sal.title.to" /></span>
              <p><input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" id="dpOrderDateTo" value="${toDay}"/></p>
            </div>
          </td>
          <th scope="row"><spring:message code="sal.text.ordNum" /></th>
          <td>
            <div class="date_set w100p">
              <p><input type="text" title="" placeholder="" class="w100p" id="txtOrderNoFr"/></p>
              <span><spring:message code="sal.title.to" /></span>
              <p><input type="text" title="" placeholder="" class="w100p" id="txtOrderNoTo"/></p>
            </div>
          </td>
        </tr>
        <tr>
          <th scope="row"><spring:message code="sal.text.custName" /></th>
          <td colspan="3"><input type="text" title="" placeholder="" class="w100p" id="txtCustName"/></td>
        </tr>
        <tr>
           <th scope="row"><spring:message code="sal.text.keyInBranch" /></th>
          <td>
            <select class="w100p" id="cmbKeyBranch"></select>
          </td>
          <th scope="row"><spring:message code="sal.text.keyInUser" /></th>
          <td>
            <input type="text" title="" placeholder="" class="w100p" id="txtUserName"/>
          </td>
        </tr>
        <tr>
          <th scope="row"><spring:message code="sal.title.text.sorting" /></th>
          <td>
            <select class="w100p" id="cmbSort">
              <!-- <option value="1">By Region</option> -->
              <option value=""><spring:message code="sal.combo.text.chooseOne" /></option>
              <option value="2"><spring:message code="sal.combo.text.byBrnch" /></option>
              <option value="3"><spring:message code="sal.combo.text.byOrdDt" /></option>
              <option value="4" selected><spring:message code="sal.combo.text.byOrdNumber" /></option>
              <option value="5"><spring:message code="sal.combo.text.byCustName" /></option>
            </select>
          </td>
          <th scope="row"></th>
          <td></td>
        </tr>
      </tbody>
    </table>

    <section class="search_result">
      <ul class="right_btns">
        <li>
          <p class="btn_grid">
            <a href="#" id="pdfDown" onclick="pdfDown()"><spring:message code="sal.btn.genPDF" /></a>
          </p>
        </li>
        <li>
          <p class="btn_grid">
            <a href="#" id="excelDown" onclick="excelDown()"><spring:message code="sal.btn.genExcel" /></a>
          </p>
        </li>
      </ul>
      <aside class="title_line">
      </aside>
      <article class="grid_wrap">
        <div id="sofList_grid" style="width: 100%; height: 340px; margin: 0 auto;"></div>
      </article>
    </section>
  </form>

  </section>
  </section>
</div>