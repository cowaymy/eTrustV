<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<!--
 DATE        BY     VERSION        REMARK
 ----------------------------------------------------------------
 28/08/2019  ONGHC  1.0.0          Create IHR
 -->
<script type="text/javaScript">
  var myGridID_ledger;
  $(document).ready(function(){
    $('.multy_select').on("change", function() {
    }).multipleSelect({});

    fn_ledgerGrid();
    fn_ledgerSearch();
  });

  function fn_ledgerSearch(){
    Common.ajax("GET", "/services/inhouse/report/getViewLedger.do", {ASRNO : "${ASRNo}" }, function(result) {
      AUIGrid.setGridData(myGridID_ledger, result);
    });
  }
  function fn_ledgerGrid() {
    var columnLayout = [ {
        dataField : "asDocNo",
        headerText : "No",
        editable : false,
        width : 130
    }, {
        dataField : "codeName",
        headerText : "Type",
        editable : false,
        width : 130
    }, {
        dataField : "c1",
        headerText : "Date",
        editable : false,
        width : 130
    }, {
        dataField : "c2",
        headerText : "Debit Amount",
        editable : false,
        width : 130
    }, {
        dataField : "c3",
        headerText : "Credit Amount",
        editable : false,
        style : "my-column",
        width : 130
    }, {
        dataField : "c4",
        headerText : "Advance Payment",
        editable : false,
        width : 130,
        renderer : {
            type : "CheckBoxEditRenderer",
            showLabel : false,
            editable : false,
            checkValue : "1",
            unCheckValue : "0"
        }
    }];

    var gridPros = {
      usePaging : true,
      pageRowCount : 20,
      editable : false,
      displayTreeOpen : false,
      selectionMode : "singleRow",
      headerHeight : 30,
      useGroupingPanel : false,
      skipReadonlyColumns : true,
      wrapSelectionMove : true,
      showRowNumColumn : true,
    };

    myGridID_ledger = AUIGrid.create("#grid_wrap_ledger", columnLayout, gridPros);
  }

  var gridPros = {
    usePaging : true,
    pageRowCount : 20,
    editable : true,
    fixedColumnCount : 1,
    showStateColumn : true,
    displayTreeOpen : true,
    selectionMode : "singleRow",
    headerHeight : 30,
    useGroupingPanel : true,
    skipReadonlyColumns : true,
    wrapSelectionMove : true,
    showRowNumColumn : false
  };
</script>
<div id="popup_wrap" class="popup_wrap">
<header class="pop_header"><!-- pop_header start -->
<h1>AS LEDGER</h1>
<ul class="right_opt">
  <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header>

<section class="pop_body">
  <article class="grid_wrap">
    <div id="grid_wrap_ledger" style="width: 100%; height: 300px; margin: 0 auto;"></div>
  </article>
</section>
</div>
