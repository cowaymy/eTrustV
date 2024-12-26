<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">
  var supSubOrderGridID;

  $(document).ready(function() {
	  createAUIGrid();
	  CommonCombo.make('cmbKeyBranch', '/sales/ccp/getBranchCodeList', '' , '', '', fn_multiComboBranch);
	  AUIGrid.bind(supSubOrderGridID, "cellDoubleClick", function(event) {
		  fn_setData(AUIGrid.getCellValue(supSubOrderGridID , event.rowIndex , "salesOrdNo"), AUIGrid.getCellValue(supSubOrderGridID , event.rowIndex , "salesOrdId"));
	  });
  });

  function fn_setData(salesOrdNo,salesOrdId) {
	  console.log("salesOrderNo : " + salesOrdNo);
	  console.log("salesOrderId : " + salesOrdId);
      $('#salesOrderNo').val(salesOrdNo);
      $('#salesOrderId').val(salesOrdId);
      $('#btnClose').click();
  }

  function fn_multiComboBranch() {
    if ($("#cmbKeyBranch option[value='${ind}']").val() === undefined) {
      $("#cmbKeyBranch").prop('disabled', false);
    } else {
      $("#cmbKeyBranch").prop('disabled', false);
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

      Common.ajax("GET", "/supplement/getSupSubOrderInfo.do", params, function(result) {
        AUIGrid.setGridData(supSubOrderGridID, result);
      });
    }
  }

  function createAUIGrid() {
      var columnLayout = [
            { headerText : "Order No",     dataField : "salesOrdNo", width : 120 }
          , { headerText : "Sof No",     dataField : "refNo",    width : 120 }
          , { headerText : "App Type",     dataField : "appType",    width : 120 }
          , { headerText : "Product Code", dataField : "stkCode",    width : 120 }
          , { headerText : "Product Name", dataField : "stkDesc"}
          , { headerText : "Promo Id",     dataField : "promoId", visible  : false }
          , { headerText : "Order Id",     dataField : "salesOrdId" , visible  : false}
          , { headerText : "Business Type",     dataField : "busType" , visible  : false}

            ];

      var gridPros = {
              usePaging           : true,         //페이징 사용
              pageRowCount        : 5,            //한 화면에 출력되는 행 개수 20(기본값:20)
              editable            : false,
              fixedColumnCount    : 0,
              showStateColumn     : false,
              displayTreeOpen     : false,
            //selectionMode       : "singleRow",  //"multipleCells",
              headerHeight        : 30,
              useGroupingPanel    : false,        //그룹핑 패널 사용
              skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
              wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
              showRowNumColumn    : true,         //줄번호 칼럼 렌더러 출력
              noDataMessage       : "No order found.",
              groupingMessage     : "Here groupping"
          };

    supSubOrderGridID = GridCommon.createAUIGrid("#orderList_grid", columnLayout, '', gridPros);
  }

</script>

<div id="popup_wrap" class="popup_wrap">
  <header class="pop_header">
    <h1><spring:message code="supplement.title.supplementOrderSearch" /></h1>
    <ul class="right_opt">
      <li><p class="btn_blue2"><a href="#" onclick="javascript:fn_search();"><spring:message code="sales.btn.search" /></a></p></li>
      <li><p class="btn_blue2"><a id="btnClose" href="#"><spring:message code="sal.btn.close" /></a></p></li>
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
              <p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" id="dpOrderDateFr" value="${toDay}"/></p>
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
          <th></th>
          <td></td>
        </tr>
      </tbody>
    </table>

    <section class="search_result">
      <ul class="right_btns">
      </ul>
      <aside class="title_line">
      </aside>
      <article class="grid_wrap">
        <div id="orderList_grid" style="width: 100%; height: 340px; margin: 0 auto;"></div>
      </article>
    </section>
  </form>
  </section>
  </section>
</div>