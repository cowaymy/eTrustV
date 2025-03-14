<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<style type="text/css">

    /* 커스텀 칼럼 스타일 정의 */
    .aui-grid-user-custom-left {
        text-align: left;
    }
</style>
<script type="text/javaScript" language="javascript">

  //AUIGrid 생성 후 반환 ID
  var addrGridID;

  $(document).ready(function(){
      //AUIGrid 그리드를 생성합니다.
        createAUIGrid();
        fn_getCustomerAddressAjax();

        // 셀 더블클릭 이벤트 바인딩
        AUIGrid.bind(addrGridID, "cellDoubleClick", function(event) {
            fn_setData(AUIGrid.getCellValue(addrGridID , event.rowIndex , "custAddId"))
            $('#custPopCloseBtn').click();
        });

        // 20190925 KR-OHK Moblie Popup Setting
        Common.setMobilePopup(false, true, 'grid_addr_wrap');
  });

  function fn_setData(custAddId) {
      if($('#callPrgm').val() == 'ORD_REGISTER_BILL_MTH' || $('#callPrgm').val() == 'ORD_MODIFY_MAIL_ADR') {
          fn_loadMailAddr(custAddId);
      }
      else if($('#callPrgm').val() == 'ORD_REGISTER_INST_ADD') {
          fn_loadInstallAddr(custAddId);
      }
      else if($('#callPrgm').val() == 'ORD_MODIFY_MAIL_ADR') {
          fn_loadMailAddr(custAddId);
      }
      else if($('#callPrgm').val() == 'ORD_MODIFY_MAIL_ADR2') {
          fn_loadMailAddress(custAddId);
      }
      else if($('#callPrgm').val() == 'ORD_MODIFY_INST_ADR') {
          fn_loadInstallAddrInfoNew(custAddId);
      }
      else if($('#addrSearchForm #callPrgm').val() == 'PRE_ORD_BILL_ADD') {
          fn_loadBillAddr(custAddId);
      }
      else if($('#addrSearchForm #callPrgm').val() == 'PRE_ORD_INST_ADD'){
        fn_loadInstallAddr(custAddId);
        fn_loadBillAddr(custAddId);
        fn_resetSales()
      }
      else{
        eval(${callPrgm}(custAddId));
      }
  }

    function createAUIGrid() {

        //AUIGrid 칼럼 설정
        var columnLayout = [{
              dataField : "name",
              headerText : '<spring:message code="sal.title.status" />',
              width : 80
          }, {
              dataField : "addr",
              headerText : '<spring:message code="sal.title.address" />',
              width : 700,
              style: "aui-grid-user-custom-left"
          },{
              dataField : "custAddId",
              visible : false
            }];

        //그리드 속성 설정
        var gridPros = {
            usePaging           : true,         //페이징 사용
            pageRowCount        : 10,           //한 화면에 출력되는 행 개수 20(기본값:20)
            editable            : false,
            fixedColumnCount    : 0,
            showStateColumn     : false,
            displayTreeOpen     : false,
    //        selectionMode       : "singleRow",  //"multipleCells",
            headerHeight        : 30,
            useGroupingPanel    : false,        //그룹핑 패널 사용
            skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
            wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
            showRowNumColumn    : true,         //줄번호 칼럼 렌더러 출력
            noDataMessage       : "No order found.",
            groupingMessage     : "Here groupping"
        };

        addrGridID = GridCommon.createAUIGrid("grid_addr_wrap", columnLayout, "", gridPros);
    }

  $(function(){
      $('#cntcSearchBtn').click(function() {
          fn_getCustomerAddressAjax();
      });
  });

    //Get Contact by Ajax
    function fn_getCustomerAddressAjax(){
        Common.ajax("GET", "/sales/customer/selectCustomerAddressJsonList", $("#addrSearchForm").serializeJSON(), function(result) {
            AUIGrid.setGridData(addrGridID, result);
        });
    }

</script>
</head>
<body>
 <div id="popup_wrap" class="popup_wrap">
  <!-- popup_wrap start -->
  <header class="pop_header">
   <!-- pop_header start -->
   <h1>
    <spring:message code="sal.page.title.custAddr" />
   </h1>
   <ul class="right_opt">
    <li><p class="btn_blue2">
      <a id="custPopCloseBtn" href="#"><spring:message
        code="sal.btn.close" /></a>
     </p></li>
   </ul>
  </header>
  <!-- pop_header end -->
  <section class="pop_body">
   <!-- pop_body start -->
   <section class="search_table">
    <!-- search_table start -->
    <form id="addrSearchForm" name="cnctSearchForm" action="#"
     method="post">
     <input id="callPrgm" name="callPrgm" value="${callPrgm}"
      type="hidden" /> <input id="custId" name="custId"
      value="${custId}" type="hidden" />
     <table class="type1">
      <!-- table start -->
      <caption>table</caption>
      <colgroup>
       <col style="width: 160px" />
       <col style="width: *" />
      </colgroup>
      <tbody>
       <tr>
        <th scope="row"><spring:message code="sal.text.addrKeyword" /></th>
        <td><input id="searchWord" name="searchWord" type="text"
         title="" placeholder="Keyword" class="w100p" /></td>
       </tr>
      </tbody>
     </table>
     <!-- table end -->
    </form>
    <section class="search_result">
     <!-- search_result start -->
     <ul class="right_btns">
      <li><p class="btn_grid">
        <a id="cntcSearchBtn" href="#""><spring:message code="sal.btn.search" /></a>
       </p></li>
      <li><p class="btn_grid">
        <a href="#"><spring:message code="sal.btn.clear" /></a>
       </p></li>
     </ul>
     <article class="grid_wrap">
      <!-- grid_wrap start -->
      <div id="grid_addr_wrap" style="width: 100%; height: 100%; margin: 0 auto;"></div>
     </article>
     <!-- grid_wrap end -->
    </section>
    <!-- search_result end -->
   </section>
   <!-- search_table end -->
  </section>
  <!-- pop_body end -->
 </div>
 <!-- popup_wrap end -->
</body>
</html>