<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<style type="text/css">
.aui-grid-body-panel .aui-grid-table tr td{
    background: white;
}

.aui-grid-button-renderer {
     border:none;
     background: transparent;
     pointer: cursor;
}
</style>

<script type="text/javaScript">
var myGridID;
var excelListGridID;

$(document).ready(function(){
	// AUIGrid 그리드를 생성합니다.
    createAUIGrid();
    createExcelAUIGrid();

	//Search
    $("#_searchBtn").click(function() {
        if(fn_validSearchlist()) fn_eGhlPaymentCollectionSearch();
    });

    //Clear
    $("#_clearBtn").click(function() {
        $('#trxDtFrom').val('');
        $('#trxDtTo').val('');
        $('#orderNo').val('');
        $('#custID').val('');
        $('#custIC').val('');
        $('#status').multipleSelect("uncheckAll");
    });

    //Excel Download
    $('#excelDown').click(function() {
    	if(fn_validSearchlist()){
	        var excelProps = {
	            fileName     : "eGHL Payment Collection List",
	           exceptColumnFields : AUIGrid.getHiddenColumnDataFields(excelListGridID)
	        };
	        AUIGrid.exportToXlsx(excelListGridID, excelProps);
    	}
    });

    $('#status').change(function() {
    }).multipleSelect({
        selectAll: true,
        width: '100%'
    });
});

function fn_validSearchlist(){
	var isValid = true, msg = "";

    if(  FormUtil.isEmpty($('#orderNo').val()) &&
         FormUtil.isEmpty($('#custID').val()) &&
         FormUtil.isEmpty($('#custIC').val()) &&
         FormUtil.isEmpty($('#status option:selected').val()) ){
        	 if(FormUtil.isEmpty($('#trxDtFrom').val()) || FormUtil.isEmpty($('#trxDtTo').val())){
        	     isValid = false;
        		 msg += "* Please Key in Transaction Date.";
        	 }

        	 if(!isValid) Common.alert('eGHL Payment Collection' + DEFAULT_DELIMITER + "<b>"+msg+"</b>");
       	 }

    return isValid;
}

function createAUIGrid() {
    //AUIGrid 칼럼 설정
    var columnLayout = [ {
        dataField : "id",
        headerText : "Payment Collection ID",
        editable : false,
        visible: false
    },{
        dataField : "crtDt",
        headerText : "Date & Time",
        editable : false,
        cellMerge : true
    }, {
    	dataField : "payNo",
        headerText : "Trans ID",
        editable : false,
        cellMerge : true,
        mergePolicy : "restrict",
        mergeRef : "crtDt"
    }, {
    	dataField : "crtUsername",
        headerText : "User Name",
        editable : false,
        cellMerge : true,
        mergePolicy : "restrict",
        mergeRef : "crtDt",
    },{
        dataField : "ordNo",
        headerText : "Order No.",
        editable : false,
    },{
        dataField : "payType",
        headerText : "Pay Type",
        editable : false
    },{
        dataField : "amount",
        headerText : "Amount (RM)",
        editable : false,
    },{
        dataField : "status",
        headerText : "Status",
        editable : false
    },{
        dataField : "payReceipt",
        headerText : "Pay Receipt",
        editable : false
    },{
        dataField : "paymentLink",
        headerText : "Link",
        editable : false,
        cellMerge : true,
        mergePolicy : "restrict",
        mergeRef : "crtDt",
        labelFunction : function(rowIndex, columnIndex, value, headerText, item, dataField, cItem) {
               // logic processing
               // Return value here, reprocessed or formatted as desired.
               // The return value of the function is immediately printed in the cell.
               if(item.statusCodeId == '44') {
                    return "Copy Link";
               } else {
                    return "-";
               }
        },
        renderer : {
            type : "ButtonRenderer",
            onclick : function(rowIndex, columnIndex, value, item) {
                   var copyText = item.statusCodeId == '44' ? value : "-";

                   if(!(copyText == "-")) {
	                    $("#copyToClipboard").val(copyText);
	                    $("#copyToClipboard").attr("type", "text").select();
	                    document.execCommand("copy");
	                    Common.alert("Copied link");
	                    $("#copyToClipboard").attr("type", "hidden");
               	   }
            }
        }
    }];

     // 그리드 속성 설정
    var gridPros = {
//                usePaging           : true,         //페이징 사용
//               pageRowCount        : 20,           //한 화면에 출력되는 행 개수 20(기본값:20)
             editable            : false,
             fixedColumnCount    : 1,
             showStateColumn     : false,
             displayTreeOpen     : false,
             selectionMode       : "multipleCells", //"singleRow",
             headerHeight        : 30,
             useGroupingPanel    : false,        //그룹핑 패널 사용
             skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
             wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
             showRowNumColumn    : true,      //줄번호 칼럼 렌더러 출력

             enableCellMerge : true,
             cellMergePolicy: "withNull",
             showRowBgStyles: false
    };

    myGridID = AUIGrid.create("#grid_wrap", columnLayout, gridPros);
}

var isMerged = true; // 최초에는 merged 상태

function setCellMerge() {
    isMerged = !isMerged;

    AUIGrid.setCellMerge(myGridID, isMerged);
}

//리스트 조회.
function fn_eGhlPaymentCollectionSearch() {
    Common.ajax("GET", "/payment/eGhlPaymentCollection/eGhlPaymentCollectionSearch", $("#searchForm").serialize(), function(result) {
        AUIGrid.setGridData(myGridID, result);
        AUIGrid.setGridData(excelListGridID, result);
    });
}

function createExcelAUIGrid(){
    //AUIGrid 칼럼 설정
    var excelColumnLayout = [ {
    	 dataField : "id",
         headerText : "Payment Collection ID",
         editable : false,
         visible: false
     },{
         dataField : "crtDt",
         headerText : "Date & Time",
         editable : false,
         width: 250,
     }, {
         dataField : "payNo",
         headerText : "Trans ID",
         editable : false,
     }, {
         dataField : "crtUsername",
         headerText : "User Name",
         editable : false,
     },{
         dataField : "ordNo",
         headerText : "Order No.",
         editable : false,
     }, {
         dataField : "amount",
         headerText : "Amount (RM)",
         editable : false,
     },{
         dataField : "status",
         headerText : "Status",
         editable : false
     },{
         dataField : "payReceipt",
         headerText : "Payment Receipt",
         editable : false
     }
//      ,{
//          dataField : "paymentLink",
//          headerText : "Link",
//          editable : false,
//          labelFunction : function(rowIndex, columnIndex, value, headerText, item, dataField, cItem) {
//                 // logic processing
//                 // Return value here, reprocessed or formatted as desired.
//                 // The return value of the function is immediately printed in the cell.
//                 if(item.statusCodeId == '44') {
//                      return "Copy Link";
//                 } else {
//                      return "-";
//                 }
//          }
//    }
    ];

    //그리드 속성 설정
    var excelGridPros = {
         enterKeyColumnBase : true,
         useContextMenu : true,
         enableFilter : true,
         showStateColumn : true,
         displayTreeOpen : true,
         noDataMessage : "<spring:message code='sys.info.grid.noDataMessage' />",
         groupingMessage : "<spring:message code='sys.info.grid.groupingMessage' />",
         exportURL : "/common/exportGrid.do"
     };

    excelListGridID = GridCommon.createAUIGrid("excel_list_grid_wrap", excelColumnLayout, "", excelGridPros);

}
</script>

<section id="content"><!-- content start -->
    <ul class="path">
        <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
        <li>Billing & Collection</li>
        <li>Collection</li>
        <li>eGHL Payment Collection</li>
    </ul>

    <aside class="title_line"><!-- title_line start -->
        <p class="fav"><a href="#" class="click_add_on">My menu</a></p>
        <h2>eGHL Payment Collection</h2>
        <ul class="right_btns">
            <li><p class="btn_blue"><a href="#" id="_searchBtn"><span class="search"></span><spring:message code="sal.btn.search" /></a></p></li>
            <li><p class="btn_blue"><a href="#" id="_clearBtn"><span class="clear"></span><spring:message code='sys.btn.clear'/></a></p></li>
        </ul>
    </aside><!-- title_line end -->

    <input type="hidden" id="copyToClipboard" name="copyToClipboard" style="visible:false"/>

    <section class="search_table"><!-- search_table start -->
        <form action="#" id="searchForm" name="searchForm" method="post">
            <table class="type1"><!-- table start -->
                <caption>table</caption>
                <colgroup>
                    <col style="width:140px" />
                    <col style="width:*" />
                    <col style="width:150px" />
                    <col style="width:*" />
                </colgroup>
                <tbody>
                    <tr>
                        <th scope="row">Transaction Date</th>
                        <td>
	                        <div class="date_set w100p"><!-- date_set start -->
						      <p><input id="trxDtFrom" name="trxDtFrom" type="text" value="" title="TrxDtFrom" placeholder="DD/MM/YYYY" class="j_date" readonly /></p>
						      <span><spring:message code="sal.title.to" /></span><span>To</span>
						      <p><input id="trxDtTo" name="trxDtTo" type="text" value="" title="TrxDtTo" placeholder="DD/MM/YYYY" class="j_date" readonly /></p>
						    </div><!-- date_set end -->
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Order Number</th>
                        <td>
                            <input type="text" title="OrderNo" placeholder="Order No." class="w100p" id="orderNo" name="orderNo" />
                        </td>
                        <th scope="row">Customer ID</th>
                        <td>
                            <input type="text" title="CustID" placeholder="Customer ID (Number Only)" class="w100p" id="custID" name="custID" />
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Customer IC</th>
                        <td>
                            <input type="text" title="CustIC" placeholder="NRIC/Company No" class="w100p" id="custIC" name="custIC" />
                        </td>
                        <th scope="row">Status</th>
                        <td>
                            <select class="w100p multy_select" id="status" name="status" multiple="multiple">
                                <option value="44">Pending</option>
                                <option value="4">Completed</option>
                                <option value="82">Expired</option>
                            </select>
                        </td>
                    </tr>
                </tbody>
            </table><!-- table end -->
        </form>
    </section><!-- search_table end -->

    <ul class="right_btns">
        <li><p class="btn_grid"><a href="#" id="excelDown">Excel DW</a></p></li>
    </ul>

    <section class="search_result"><!-- search_result start -->
        <article class="grid_wrap"><!-- grid_wrap start -->
            <div id="grid_wrap" style="width:100%; height:480px; margin:0 auto;"></div>
            <div id="excel_list_grid_wrap" style="display: none;"></div>
        </article><!-- grid_wrap end -->
    </section><!-- search_result end -->
</section><!-- content end -->