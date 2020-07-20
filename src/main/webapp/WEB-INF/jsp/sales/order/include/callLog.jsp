
<!--
 DATE        BY     VERSION        REMARK
 ----------------------------------------------------------------
 20/07/2020  ONGHC  1.0.1       Add Installation Status and Installation Fail Image
 -->

<script type="text/javaScript" language="javascript">
  var callLogGridID;

  $(document).ready(function() {
    createAUIGrid4();
  });

  function createAUIGrid4() {

    //AUIGrid 칼럼 설정
    var columnLayout = [
        {
          headerText : '<spring:message code="sal.title.text.no" />',
          dataField : "rownum",
          visible : false
        }, {
          headerText : '<spring:message code="sal.text.type" />',
          dataField : "codeName",
          width : 150
        }, {
          headerText : '<spring:message code="sal.title.text.feedback" />',
          dataField : "resnDesc",
          width : 120
        }, {
          headerText : '<spring:message code="sal.title.text.action" />',
          dataField : "stusName",
          width : 120
        }, {
          headerText : '<spring:message code="sal.title.amount" />',
          dataField : "callRosAmt",
          width : 70
        }, {
          headerText : '<spring:message code="sal.text.remark" />',
          dataField : "callRem",
          width : 250
        }, {
          headerText : '<spring:message code="sal.title.text.caller" />',
          dataField : "rosCallerUserName",
          width : 120
        }, {
          headerText : '<spring:message code="sal.text.creator" />',
          dataField : "callCrtUserName",
          width : 80
        }, {
          headerText : '<spring:message code="sal.text.createDate" />',
          dataField : "callCrtDt",
          width : 130
        }, {
          headerText : '<spring:message code="service.title.InstallationStatus" />',
          dataField : "insStat",
          width : 120
        }, {
          headerText : '<spring:message code="service.title.InstallationNo" />',
          dataField : "insNo",
          width : 130,
          visible : true
        }, {
          //headerText : '<spring:message code="sal.text.createDate" />',
          //dataField : "insNo",
          //width : 130
          dataField : "undefined",
           headerText : "View",
           width : 100,
           renderer : {
             type : "ButtonRenderer",
             labelText : "View",
             onclick : function(rowIndex, columnIndex, value, item) {
            //$("#_insNo").val(item.insNo);
            console.log(item);

            Common.popupDiv('/sales/order/getInstImg.do', { ordNo : '${orderDetail.basicInfo.ordNo}', insNo : item.insNo }, null , true);
          }
        }
        }];

    var gridPros = {
      usePaging : true, //페이징 사용
      pageRowCount : 10, //한 화면에 출력되는 행 개수 20(기본값:20)
      editable : false,
      fixedColumnCount : 0,
      showStateColumn : false,
      displayTreeOpen : false,
      //selectionMode       : "singleRow",  //"multipleCells",
      headerHeight : 30,
      useGroupingPanel : false, //그룹핑 패널 사용
      skipReadonlyColumns : true, //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
      wrapSelectionMove : true, //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
      showRowNumColumn : true, //줄번호 칼럼 렌더러 출력
      noDataMessage : "No order found.",
      groupingMessage : "Here groupping",
      wordWrap : true
    };
    callLogGridID = GridCommon.createAUIGrid("grid_callLog_wrap", columnLayout, "", gridPros);
  }

  // 리스트 조회.
  function fn_selectCallLogList() {
    Common.ajax("GET", "/sales/order/selectCallLogJsonList.do", {
      salesOrderId : '${orderDetail.basicInfo.ordId}'
    }, function(result) {
      AUIGrid.setGridData(callLogGridID, result);
    });
  }
</script>
<article class="tap_area">
  <!-- tap_area start -->
  <article class="grid_wrap">
    <!-- grid_wrap start -->
    <div id="grid_callLog_wrap" style="width: 100%;
  height: 380px;
  margin: 0 auto;"></div>
  </article>
  <!-- grid_wrap end -->
</article>
<!-- tap_area end -->