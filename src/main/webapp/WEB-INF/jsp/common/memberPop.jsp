<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<script type="text/javaScript" language="javascript">
  //AUIGrid 생성 후 반환 ID
  var myGridID;
  var callPrgm = '${callPrgm}';

  $(document).ready(function() {
    //AUIGrid 그리드를 생성합니다.
    createAUIGrid();

    doGetCombo('/common/selectCodeList.do', '1', '', 'popMemType', 'S', ''); //Common Code
    doGetComboSepa('/common/selectBranchCodeList.do', '1', ' - ', '', 'popBrnchId', 'S', ''); //Branch Code

    // 셀 더블클릭 이벤트 바인딩
    AUIGrid.bind(myGridID, "cellDoubleClick", function(event) {

      if (callPrgm == "TR_BOOK_ASSIGN") {
        fn_loadOrderSalesman(AUIGrid.getCellValue(myGridID, event.rowIndex, "memType"), AUIGrid.getCellValue(myGridID, event.rowIndex, "memTypeName"), AUIGrid.getCellValue(myGridID, event.rowIndex, "memId"), AUIGrid.getCellValue(myGridID, event.rowIndex, "memCode"), AUIGrid.getCellValue(myGridID, event.rowIndex, "name"));

      } else if (callPrgm == 'PAYMENT_PROCESS') {
        fn_loadOrderSalesman(AUIGrid.getCellValue(myGridID, event.rowIndex, "memId"), AUIGrid.getCellValue(myGridID, event.rowIndex, "memCode"), AUIGrid.getCellValue(myGridID, event.rowIndex, "name"));

      } else if (callPrgm == "PREORD_LIST") {
        fn_loadOrderSalesman(AUIGrid.getCellValue(myGridID, event.rowIndex, "memCode"));
      } else if (callPrgm == "APPROVAL_LINE") {
    	  fn_loadOrderSalesmanApprovalLine(AUIGrid.getCellValue(myGridID, event.rowIndex, "memId"), AUIGrid.getCellValue(myGridID, event.rowIndex, "memCode"), callPrgm);
      }else {
        fn_loadOrderSalesman(AUIGrid.getCellValue(myGridID, event.rowIndex, "memId"), AUIGrid.getCellValue(myGridID, event.rowIndex, "memCode"), callPrgm);
      }

      $("#memPopCloseBtn").click();
    });

    // 20190925 KR-OHK Moblie Popup Setting
    Common.setMobilePopup(false, true, 'grid_mem_wrap');
  });

  function createAUIGrid() {

    //AUIGrid 칼럼 설정
    var columnLayout = [
        {
          dataField : "memId",
          headerText : "Member ID",
          width : 120
        }, {
          dataField : "memCode",
          headerText : "Member Code",
          width : 120
        }, {
          dataField : "memTypeName",
          headerText : "Member Type",
          width : 120
        }, {
          dataField : "name",
          headerText : "Member Name"
        }, {
          dataField : "nric",
          headerText : "Member IC",
          width : 120
        }, {
          dataField : "memType",
          headerText : "memType",
          visible : false
        }];

    //그리드 속성 설정
    var gridPros = {
      usePaging : true, //페이징 사용
      pageRowCount : 10, //한 화면에 출력되는 행 개수 20(기본값:20)
      editable : false,
      fixedColumnCount : 0,
      showStateColumn : false,
      displayTreeOpen : false,
      selectionMode : "singleRow", //"multipleCells",
      headerHeight : 30,
      useGroupingPanel : false, //그룹핑 패널 사용
      skipReadonlyColumns : true, //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
      wrapSelectionMove : true, //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
      showRowNumColumn : true, //줄번호 칼럼 렌더러 출력
      noDataMessage : "No order found.",
      groupingMessage : "Here groupping"
    };

    if (callPrgm == "NRIC_VISIBLE" || callPrgm == "APPROVAL_LINE") {
      columnLayout[4].visible = false;
    }

    myGridID = GridCommon.createAUIGrid("grid_mem_wrap", columnLayout, "", gridPros);
  }

  // 리스트 조회.
  function fn_selectMemberList() {
	  $("#GOC").val();
		    if (callPrgm == "MEM_NO_STAT") {
		      $("#status").val("");
		    } else {
		      $("#status").val("1")
		    }

    Common.ajax("GET", "/sales/order/selectMemberList.do", $("#searchMemberFormPop").serialize(), function(result) {
      AUIGrid.setGridData(myGridID, result);
    });
  }

  $(function() {
    $('#searchBtn').click(function() {
      fn_selectMemberList();
    });
  });

  $(function() {
    $('#clearBtn').click(function() {
      $("#searchMemberFormPop").each(function() {
        this.reset();
      });
    });
  });
</script>
</head>
<body>
  <div id="popup_wrap" class="popup_wrap">
    <!-- popup_wrap start -->
    <header class="pop_header">
      <!-- pop_header start -->
      <h1>Search Member</h1>
      <ul class="right_opt">
        <li><p class="btn_blue2"><a id="memPopCloseBtn" href="#">CLOSE</a></p></li>
      </ul>
    </header>
    <!-- pop_header end -->
    <section class="pop_body">
      <!-- pop_body start -->
      <aside class="title_line">
        <!-- title_line start -->
        <ul class="right_btns">
          <li><p class="btn_blue"><a id="searchBtn" href="#"><span class="search"></span>SEARCH</a></p></li>
          <li><p class="btn_blue"><a id="clearBtn" href="javascript:void(0);"><span class="clear"></span>CLEAR</a></p></li>
        </ul>
      </aside>
      <!-- title_line end -->
      <section class="search_table">
        <!-- search_table start -->
        <form id="searchMemberFormPop" name="searchMemberFormPop" action="#" method="post">
         <input type="hidden" id="status" name="status" />
         <input type="hidden" id="GOC" name="GOC" value = "2" />
          <table class="type1">
            <!-- table start -->
            <caption>table</caption>
            <colgroup>
              <col style="width: 40%" />
              <col style="width: *" />
            </colgroup>
            <tbody>
              <tr>
                <th scope="row">Member Type</th>
                <td>
                  <select id="popMemType" name="memType" class="w100p"></select>
                </td>
              </tr>
              <tr>
                <th scope="row">Member Code</th>
                <td>
                  <input id="popMemCd" name="memCode" type="text" title="" placeholder="" class="w100p" />
                </td>
              </tr>
              <tr>
                <th scope="row">Member Name</th>
                <td>
                  <input id="popMemNm" name="name" type="text" title="" placeholder="" class="w100p" />
                </td>
              </tr>
              <tr>
                <th scope="row">IC Number</th>
                <td>
                  <input id="popIcNum" name="nric" type="text" title="" placeholder="" class="w100p" />
                </td>
              </tr>
              <tr>
                <th scope="row">Branch</th>
                <td>
                  <select id="popBrnchId" name="brnch" class="w100p"></select>
                </td>
              </tr>
            </tbody>
          </table>
          <!-- table end -->
          <section class="search_result">
            <!-- search_result start -->
            <article class="grid_wrap">
              <!-- grid_wrap start -->
              <div id="grid_mem_wrap" style="width: 100%;height: 100%;margin: 0 auto;"></div>
            </article>
            <!-- grid_wrap end -->
          </section>
          <!-- search_result end -->
        </form>
      </section>
      <!-- search_table end -->
    </section>
    <!-- pop_body end -->
  </div>
  <!-- popup_wrap end -->
</body>
</html>