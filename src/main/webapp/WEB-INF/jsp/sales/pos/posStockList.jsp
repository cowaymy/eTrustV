<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp" %>

<style type="text/css">
	/* 커스텀 칼럼 스타일 정의 */
	.aui-grid-user-custom-left {
	    text-align:left;
	}
	.aui-grid-user-custom-right {
	    text-align:right;
	}

	/* 커스컴 disable 스타일*/
	.mycustom-disable-color {
	    color : #cccccc;
	}

	/* 그리드 오버 시 행 선택자 만들기 */
	.aui-grid-body-panel table tr:hover {
	    background:#D9E5FF;
	    color:#000;
	}
	.aui-grid-main-panel .aui-grid-body-panel table tr td:hover {
	    background:#D9E5FF;
	    color:#000;
	}
</style>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery.blockUI.min.js"></script>
<script type="text/javaScript" language="javascript">

//AUIGrid  ID
var mstGridID;
var myGridID;
let selVal = '${branchId}';

function fn_excelDown(){
    // type : "xlsx", "csv", "txt", "xml", "json", "pdf", "object"
    GridCommon.exportTo("grid_wrap_excel", "xlsx", "Movement Raw Data_Stock Card");
}

$(document).ready(function(){

    var stockMoveTypecomboData = [ {"codeId": "T","codeName": "Stock Transfer"} ,{"codeId": "I","codeName": "Stock In"} ,{"codeId": "A","codeName": "Adjustment"},{"codeId": "R","codeName": "Retrun"}   ];
    doDefCombo(stockMoveTypecomboData, '' ,'scnMoveType', 'S', '');

    var stockgradecomboData = [ {"codeId": "A","codeName": "ACT"} ,{"codeId": "C","codeName": "COM"} ,{"codeId": "R","codeName": "REJECT"}  ];
    doDefCombo(stockgradecomboData, '' ,'scnMoveStat', 'S', '');

    createAUIGrid(columnLayout);
    createAUIGridExcel(excelLayout);

});

var groupList = [" ", "A", "B", "C" ];
var groupYnList = ["Y", "N" ];

var columnLayout = [
                    {dataField: "scnNo",headerText :"SCN No." ,width:  180   ,height:30 , visible:true, editable : false},
                    {dataField: "scnMoveTypeCode",headerText :"MovementType" ,width: 180    ,height:30 , visible:true, editable : false},
                    {dataField: "scnFromLocDesc",headerText :"From",width:220 ,height:30 , visible:true, editable : false},
                    {dataField: "scnToLocDesc",headerText :"TO" ,width:220 ,height:30 , visible:true, editable : false},
                    {dataField: "scnMoveStatCode",headerText :"Status",width:120   ,height:30 , visible:true, editable : false},
                    {dataField: "crtDt",headerText : "Create Date" , width:140,height:30 , visible:true ,editable : false},
                    {dataField: "crdName",headerText :"Create By" , width:140 ,height:30 , visible:true ,editable : false},
                    {dataField: "updDate",headerText :"Update Date", width:120,height:30 , visible:true,editable : false},
                    {dataField: "updName",headerText :"Update By" , width:120 ,height:30 , visible:true,editable : false},
                    {dataField: "scnMoveStat",headerText :"scnMoveStat", width:120 ,height:30 , visible:false ,editable : false},
                    {dataField: "scnMoveType",headerText :"scnMoveType", width:120 ,height:30 , visible:false,editable : false},
           ];

var excelLayout = [
                    {dataField: "scnNo",headerText :"SCN No." ,width:  180   ,height:30 , visible:true, editable : false},
                    {dataField: "scnMoveTypeCode",headerText :"Movement Type" ,width: 180    ,height:30 , visible:true, editable : false},
                    {dataField: "scnMoveStatCode",headerText :"Movement Status" ,width: 180    ,height:30 , visible:true, editable : false},
                    {dataField: "codeName",headerText :"Category",width: 180 ,height:30 , visible:true, editable : false},
                    {dataField: "itemType",headerText :"Item Type",width:120 ,height:30 , visible:true,editable : false},
                    {dataField: "itemDesc",headerText :"Item"          ,width:250   ,height:30 , visible:true,editable : false},
                    {dataField: "itemInvtQty",headerText :"Quantity"          ,width:120   ,height:30 , visible:true,editable : false},
                    {dataField: "scnFromLocDesc",headerText :"From Location"          ,width:250   ,height:30 , visible:true, editable : false},
                    {dataField: "scnToLocDesc",headerText :"To Location"          ,width:250   ,height:30 , visible:true, editable : false},
                    {dataField: "scnMoveQty",headerText :"Movement Quantity"          ,width:250   ,height:30 , visible:true, editable : false},
                    {dataField: "crtDt",headerText :"Create Date"          ,width:140   ,height:30 , visible:true ,editable : false},
                    {dataField: "crdName",headerText :"Create ID"          ,width:140   ,height:30 , visible:true ,editable : false},
                    {dataField: "updDate",headerText :"Update Date"          ,width:140   ,height:30 , visible:true ,editable : false},
                    {dataField: "updName",headerText :"Update ID"          ,width:140   ,height:30 , visible:true ,editable : false},
                    {dataField: "itemReason",headerText :"Reason"          ,width:140   ,height:30 , visible:true, editable : false},
                    {dataField: "itemRejRemark",headerText :"Remark"          ,width:140   ,height:30 , visible:true ,editable : false},
                    {dataField: "scnMoveDate",headerText :"Move Date"          ,width:140   ,height:30 , visible:true ,editable : false},
                    {dataField: "keyInBranch",headerText :"Key In Branch"          ,width:250   ,height:30 , visible:true ,editable : false},
                    {dataField: "itemPurhOrdNo",headerText :"Purchase Order No"          ,width:250   ,height:30 , visible:true ,editable : false},
                    {dataField: "itemCond",headerText :"Condition"          ,width:250   ,height:30 , visible:true ,editable : false},
           ];

createAUIGrid =function(columnLayout ){
    var auiGridProps = {
            selectionMode : "multipleCells",
            showRowNumColumn : true,
            showRowCheckColumn : false,
            showStateColumn : true,
            enableColumnResize : false,
            enableMovingColumn : false
        };

        // 실제로 #grid_wrap 에 그리드 생성
        mstGridID = AUIGrid.create("#grid_wrap", columnLayout, auiGridProps);

        // 에디팅 시작 이벤트 바인딩
        AUIGrid.bind(mstGridID, "cellEditBegin", auiCellEditingHandler);

        // 에디팅 정상 종료 이벤트 바인딩
        AUIGrid.bind(mstGridID, "cellEditEnd", auiCellEditingHandler);

        // 에디팅 취소 이벤트 바인딩
        AUIGrid.bind(mstGridID, "cellEditCancel", auiCellEditingHandler);

        // cellClick event.
        AUIGrid.bind(mstGridID, "cellDoubleClick", function( event ) {
            fn_selectPosStockMgmtViewPop( event.item.scnNo);
        });
}

createAUIGridExcel =function(excelLayout ){
    var auiGridPropsExcel = {
            selectionMode : "multipleCells",
            showRowNumColumn : true,
            showRowCheckColumn : false,
            showStateColumn : true,
            enableColumnResize : false,
            enableMovingColumn : false
        };
      myGrid = AUIGrid.create("#grid_wrap_excel", excelLayout, auiGridPropsExcel);
}

auiCellEditingHandler= function(event)    {
        if(event.type == "cellEditBegin") {
            //$("#editBeginDesc").text("에디팅 시작(cellEditBegin) : ( " + event.rowIndex + ", " + event.columnIndex + " ) " + event.headerText + ", value : " + event.value);
        } else if(event.type == "cellEditEnd") {
            //$("#editBeginEnd").text("에디팅 종료(cellEditEnd) : ( " + event.rowIndex + ", " + event.columnIndex + " ) " + event.headerText + ", value : " + event.value);
        } else if(event.type == "cellEditCancel") {
            //$("#editBeginEnd").text("에디팅 취소(cellEditCancel) : ( " + event.rowIndex + ", " + event.columnIndex + " ) " + event.headerText + ", value : " + event.value);
        }
}

// 리스트 조회.
fn_getDataListAjax  = function () {
     Common.ajax("GET", "/sales/posstock/selectPosStockMgmtList.do", $("#searchForm").serialize(), function(result) {
        AUIGrid.setGridData(mstGridID, result);
    });

     Common.ajax("GET", "/sales/posstock/selectPosStockMgmtDetailsList.do", $("#searchForm").serialize(), function(result) {
         AUIGrid.setGridData(myGrid, result);
     });
}

fn_selectPosStockMgmtViewPop =function (scnNo){
    Common.popupDiv("/sales/posstock/selectPosStockMgmtViewList.do?mode=view&scnNo="+scnNo, null, null , true , "_insDiv");
}

fn_selectPosStockMgmtAddPop =function (){
    Common.popupDiv("/sales/posstock/selectPosStockMgmtAddList.do", '' , null , true , "_insDiv");
}

fn_selectPosStockMgmtRetrunPop =function (){
    Common.popupDiv("/sales/posstock/selectPosStockMgmtReturnList.do", '' , null , true , "_insDiv");
}


fn_selectPosStockMgmtAdjPop =function (){

     var selectedItems = AUIGrid.getSelectedItems(mstGridID);
     if(selectedItems.length <= 0) return;

     if(selectedItems[0].item.scnMoveStatCode !="R"  && selectedItems[0].item.scnMoveStatCode !="A"){
         Common.alert('* Please check the Movement type \n "Return & Adjust"  is available only' );
         return ;
     }

     var scnNo = selectedItems[0].item.scnNo;
     Common.popupDiv("/sales/posstock/selectPosStockMgmtAdjList.do?scnNo="+scnNo, '' , null , true , "_insDiv");
}

fn_selectPosStockMgmtNewAdjPop = function (){
     Common.popupDiv("/sales/posstock/selectPosStockMgmtNewAdjList.do", '' , null , true , "_insDiv");
}


fn_selectPosStockMgmtTransPop = function (){
    Common.popupDiv("/sales/posstock/selectPosStockMgmtTransList.do", '' , null , true , "_insDiv");
}


fn_selectPosStockMgmtApprovalPop =function (){

    var selectedItems = AUIGrid.getSelectedItems(mstGridID);
    if(selectedItems.length <= 0) return;

    if(selectedItems[0].item.scnMoveType  !="R"){
        Common.alert('* Please check the Movement Type\n "Return"  Movement Type  is available only');
        return ;
    }

    if(selectedItems[0].item.scnMoveStat  !="A"){
        Common.alert('* Please check the status \n "ACT" status is only available');
        return ;
    }

    var scnNo = selectedItems[0].item.scnNo;
    Common.popupDiv("/sales/posstock/selectPosStockMgmtApprovalList.do?scnNo="+scnNo, '' , null , true , "_insDiv");

}

fn_selectPosStockMgmtReceivedPop=function (){

     var selectedItems = AUIGrid.getSelectedItems(mstGridID);
     if(selectedItems.length <= 0) return;

     if(selectedItems[0].item.scnMoveType  =="R"){
         Common.alert('* Please  Using the approval button. ');
         return ;
     }
     if(selectedItems[0].item.scnMoveStat  !="A"){
         Common.alert('* Please check the status \n "ACT" status is only available');
         return ;
     }

     var scnNo = selectedItems[0].item.scnNo;
     Common.popupDiv("/sales/posstock/selectPosStockMgmtReceivedList.do?scnNo="+scnNo, '' , null , true , "_insDiv");
}

fn_stockCard = function (){
	Common.popupDiv("/sales/posstock/posStockCardRawPop.do", '' , null , true , "_insDiv");
}

</script>

 <c:if test="${PAGE_AUTH.funcUserDefine5 == 'Y'}">
     <script>
	      CommonCombo.make('scnFromLocId', "/sales/pos/selectWhSOBrnchList", null ,selVal, '');
     </script>
 </c:if>


 <c:if test="${PAGE_AUTH.funcUserDefine6 == 'Y'}">
     <script>
          CommonCombo.make('scnFromLocId', "/sales/pos/selectWhSOBrnchList", {code: "SO"} ,selVal, '');
     </script>
 </c:if>

 <c:if test="${PAGE_AUTH.funcUserDefine7 == 'Y'}">
     <script>
          CommonCombo.make('scnFromLocId', "/sales/pos/selectWhSOBrnchList", {code: "CDB"} ,selVal, '');
     </script>
 </c:if>

<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>Point of Sales</li>
    <li>Stock Management</li>
    <li>Movement</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>Movement</h2>
</aside><!-- title_line end -->


<form id="searchForm" name="searchForm" method="post" onsubmit="return false;">

<aside class="title_line"><!-- title_line start -->
<h3>Header Info</h3>
    <ul class="right_btns">
<%-- <c:if test="${PAGE_AUTH.funcView == 'Y'}">
</c:if> --%>


<c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
       <li><p class="btn_blue"><a id="addItemBtn"  onclick="javascript:fn_selectPosStockMgmtAddPop();" ><span class="add"></span>ADD</a></p></li>
       <li><p class="btn_blue"><a id="adjItemBtn"  onclick="javascript:fn_selectPosStockMgmtNewAdjPop();" ><span class="edit"></span> ADJUST</a></p></li>
</c:if>

       <!--   <li><p class="btn_blue"><a id="adjItemBtn"  onclick="javascript:fn_selectPosStockMgmtAdjPop();" ><span class="edit"></span>ADJUST</a></p></li> -->
       <li><p class="btn_blue"><a id="rtnItemBtn"  onclick="javascript:fn_selectPosStockMgmtRetrunPop();" ><span class="edit"></span>RETRUN</a></p></li>
       <li><p class="btn_blue"><a id="transItemBtn"  onclick="javascript:fn_selectPosStockMgmtTransPop();" ><span class="edit"></span>TRANSFER</a></p></li>
<c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
       <li><p class="btn_blue"><a id="rtnItemBtn"  onclick="javascript:fn_selectPosStockMgmtApprovalPop();" ><span class="edit"></span>APPROVAL</a></p></li>
</c:if>
       <li><p class="btn_blue"><a id="search" onclick="javascript:fn_getDataListAjax();"  ><span class="search"   ></span>Search</a></p></li>
       <li><p class="btn_blue"><a id="clear"><span class="clear"></span>Clear</a></p></li>
    </ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
        <table summary="search table" class="type1"><!-- table start -->
            <caption>search table</caption>
            <colgroup>
                <col style="width:150px" />
                <col style="width:*" />
                <col style="width:160px" />
                <col style="width:*" />
                <col style="width:160px" />
                <col style="width:*" />
            </colgroup>
            <tbody>
                 <tr>
                   <th scope="row">SCN Number</th>
                   <td>
                     <input  type="text" id="scnNo" name="scnNo"  ></input>
                   </td>
                   <th scope="row">Movement Type</th>
                   <td>
                        <select class="w100p" id="scnMoveType" name="scnMoveType" ></select>
                   </td>
                   <th scope="row">Movement Status</th>
                   <td>
                     <select class="w100p" id="scnMoveStat" name="scnMoveStat"></select>
                   </td>
                </tr>

             <tr>
                   <th scope="row">Branch / Warehouse</th>
                   <td>
                     <select class="w100p" id="scnFromLocId" name="scnFromLocId"  ></select>
                   </td>
                    <th scope="row">Movement Date</th>
                    <td >
                        <div class="date_set w100p"><!-- date_set start -->
                        <p><input id="scnMoveSdate" name="scnMoveSdate" type="text" title="Create start Date" value="${bfDay}" placeholder="DD/MM/YYYY" class="j_date"></p>
                        <span> To </span>
                        <p><input id="scnMoveEdate" name="scnMoveEdate" type="text" title="Create End Date" value="${toDay}" placeholder="DD/MM/YYYY" class="j_date"></p>
                        </div><!-- date_set end -->
                    </td>

                   <th scope="row"></th>
                   <td> </td>
                </tr>
                </tr>
             </tbody>
        </table><!-- table end -->
    </section><!-- search_table end -->


  </form>

<aside class="link_btns_wrap">
    <!-- link_btns_wrap start -->
    <p class="show_btn">
     <a href="#"><img
      src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif"
      alt="link show" /></a>
    </p>
    <dl class="link_list">
     <dt>Link</dt>
     <dd>
      <ul class="btns">
       <c:if test="${PAGE_AUTH.funcUserDefine4 == 'Y'}">
        <li><p class="link_btn type2">
          <a href="#" onClick="fn_stockCard()">Stock Card</a>
         </p></li>
       </c:if>
      </ul>
      <p class="hide_btn">
       <a href="#"><img
        src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif"
        alt="hide" /></a>
      </p>
     </dd>
    </dl>
   </aside>

    <!-- data body start -->
    <section class="search_result"><!-- search_result start -->

        <ul class="right_btns">
<!--<c:if test="${PAGE_AUTH.funcChange == 'Y'}"> -->
           <!--  <li><p class="btn_grid"><a id="re">Recalculate</a></p></li> -->

<!-- </c:if> -->
            <li><p class="btn_grid"><a id="updateStatus" onclick="fn_selectPosStockMgmtReceivedPop();" >Update Status</a></p></li>

            <c:if test="${PAGE_AUTH.funcPrint == 'Y'}">
            <li><p class="btn_grid"><a href="javascript:fn_excelDown();">GENERATE</a></p></li>
            </c:if>

        </ul>

         <div id="grid_wrap" class="mt10" style="height:430px;"></div>
      <div id="grid_wrap_excel" class="mt10" style="height:430px;display:none;"></div>

         <ul class="center_btns mt20">
    </ul>

 </section><!-- search_result end -->

</section>