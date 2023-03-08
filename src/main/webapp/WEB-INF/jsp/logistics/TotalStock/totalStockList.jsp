<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp" %>

<style type="text/css">

/* 커스텀 칼럼 스타일 정의 */
.aui-grid-user-custom-left {
    text-align:left;
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

.aui-grid-column-right {
     text-align: right;
 }

.aui-grid-link-renderer1 {
     text-decoration:underline;
     color: #4374D9 !important;
     text-align: right;
 }

</style>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery.blockUI.min.js"></script>
<script type="text/javaScript" language="javascript">
var listGrid;
var subGrid;
var userCode;
var roleId = '${SESSION_INFO.roleId}';

var rescolumnLayout=[{dataField:    "rnum",headerText :"<spring:message code='log.head.rownum'/>"               ,width:120    ,height:30 , visible:false},
                     {dataField: "stkCode",headerText :"<spring:message code='log.head.matcode'/>"       ,width:120    ,height:30 },
                     {dataField: "stkDesc",headerText :"Mat. Name"       ,width:120    ,height:30                },
                     {dataField: "ctgryId",headerText :"<spring:message code='log.head.categoryid'/>"            ,width:120    ,height:30,visible:false  },
                     {dataField: "ctgryName",headerText :"<spring:message code='log.head.category'/>"              ,width:120    ,height:30                },
                     {dataField: "typeId",headerText :"<spring:message code='log.head.typeid'/>"             ,width:120    ,height:30,visible:false },
                     {dataField: "typeName",headerText :"<spring:message code='log.head.type'/>"               ,width:120    ,height:30 },
                     {dataField: "whLocCode",headerText :"<spring:message code='log.head.locationcode'/>"     ,width :120 ,height : 30},
                     {dataField: "locDesc",headerText :"<spring:message code='log.head.location'/>"            ,width:120    ,height:30 },
                     {dataField: "whlocgb",headerText :"<spring:message code='log.head.locationgrade'/>"     ,width:120    ,height:30 },
                     {dataField: "qty",headerText :"<spring:message code='log.head.qty'/>"                  ,width:120    ,height:30,
                    	 dataType:"numeric",
                         formatString:"#,##0",
                         styleFunction :  function(rowIndex, columnIndex, value, headerText, item, dataField) {
                             if(item.serialRequireChkYn == "Y"){
                                 return "aui-grid-link-renderer1";
                             }
                             return "aui-grid-column-right";
                         }

                     },
                     {dataField: "movQty",headerText :"In-Transit Qty"      ,width:120    ,height:30 , style:"aui-grid-column-right" , dataType:"numeric", formatString:"#,##0"            },
                     {dataField: "bookingQty",headerText :"Book Qty"        ,width:120    ,height:30 , style:"aui-grid-column-right" , dataType:"numeric", formatString:"#,##0"              },
                     {dataField: "availableQty",headerText :"<spring:message code='log.head.availableqty'/>"      ,width:120    ,height:30  , style:"aui-grid-column-right" , dataType:"numeric", formatString:"#,##0"            },
                     {dataField: "brnchCode",headerText :"Branch Code"        ,width:120    ,height:30                },
                     {dataField: "brnchName",headerText :"Branch Name"        ,width:120    ,height:30                },
                     {dataField: "cdcCode",headerText :"CDC Code"        ,width:120    ,height:30                },
                     {dataField: "cdcName",headerText :"CDC Name"        ,width:120    ,height:30                },
                     {dataField: "locId",headerText :"LOC ID"        ,width:120    ,height:30                },
                     {dataField: "serialRequireChkYn",headerText :"SERIAL_REQUIRE_CHK_YN"        ,width:120    ,height:30 ,visible:false               }

                      ];

//var reqop = {editable : false,usePaging : false ,showStateColumn : false};
var gridoptions = {
        showStateColumn : false ,
        editable : false,
        useGroupingPanel : false
        };

var subgridpros = {
        // 페이지 설정
        usePaging : true,
        pageRowCount : 20,
        editable : false,
        noDataMessage : "출력할 데이터가 없습니다.",
        enableSorting : true,
        //selectionMode : "multipleRows",
        //selectionMode : "multipleCells",
        useGroupingPanel : true,
        // 체크박스 표시 설정
        showRowCheckColumn : true,
        // 전체 체크박스 표시 설정
        showRowAllCheckBox : true,
        //softRemoveRowMode:false
        };
var resop = {
        rowIdField : "rnum",
        editable : true,
        fixedColumnCount : 6,
        groupingFields : ["reqstno"],
        displayTreeOpen : true,
        showRowCheckColumn : true ,
        enableCellMerge : true,
        showStateColumn : false,
        showRowAllCheckBox : true,
        showBranchOnGrouping : false
        };



var paramdata;

$(document).ready(function(){

    SearchSessionAjax();
    /**********************************
    * Header Setting
    **********************************/
    var LocData = {sLoc : userCode};
    //doGetComboCodeId('/common/selectStockLocationList.do',LocData, '','searchLoc', 'S' , '');
    doGetCombo('/common/selectCodeList.do', '15', '', 'searchType', 'M','f_multiComboType');
    doGetCombo('/common/selectCodeList.do', '11', '','searchCtgry', 'M' , 'f_multiCombos');
    doGetComboData('/common/selectCodeList.do', { groupCode : 339 , orderValue : 'CODE'}, '', 'searchlocgb', 'M','f_multiCombo');
    doGetComboData('/common/selectCodeList.do', { groupCode : 383 , orderValue : 'CODE'}, 'A', 'searchlocgrade', 'S','');

    doGetComboData('/logistics/totalstock/selectTotalBranchList.do','', '', 'searchBranch', 'S','');
    doGetComboData('/logistics/totalstock/selectCDCList.do', '', '','searchCDC', 'S' , '');

    //

    /**********************************
     * Header Setting End
     ***********************************/

    listGrid = AUIGrid.create("#main_grid_wrap", rescolumnLayout, gridoptions);


    //$("#sub_grid_wrap").hide();


    AUIGrid.bind(listGrid, "cellClick", function( event ) {

        var dataField = AUIGrid.getDataFieldByColumnIndex(listGrid, event.columnIndex);

        if(dataField == "qty" ){
            var rowIndex = event.rowIndex;
            var serialRequireChkYn = AUIGrid.getCellValue(listGrid, event.rowIndex, "serialRequireChkYn");
                if(serialRequireChkYn == "Y"){

                $('#pLocationType').val( AUIGrid.getCellValue(listGrid, rowIndex, "whlocgb") );
                $('#pLocationCode').val( AUIGrid.getCellValue(listGrid, rowIndex, "locId") );
                $('#pItemCodeOrName').val( AUIGrid.getCellValue(listGrid, rowIndex, "stkCode") );
                fn_serialSearchPop();
            }

        }

    });

    AUIGrid.bind(listGrid, "cellDoubleClick", function(event){

    });

    AUIGrid.bind(listGrid, "ready", function(event) {
    });



});


//btn clickevent
$(function(){
    $('#search').click(function() {
        if (f_validatation()){
            SearchListAjax();
        }
    });
    $('#clear').click(function() {
        $('#searchMatCode').val('');
        $('#searchMatName').val('');
        doGetCombo('/common/selectCodeList.do', '15', '', 'searchType', 'M','f_multiComboType');
        doGetCombo('/common/selectCodeList.do', '11', '','searchCtgry', 'M' , 'f_multiCombos');
        doGetComboData('/common/selectCodeList.do', { groupCode : 339 , orderValue : 'CODE'}, '', 'searchlocgb', 'M','f_multiCombo');
    });

    $('#searchMatName').keypress(function(event) {
        $('#searchMatCode').val('');
        if (event.which == '13') {
            $("#stype").val('stock');
            $("#svalue").val($('#searchMatName').val());
            $("#sUrl").val("/logistics/material/materialcdsearch.do");
            Common.searchpopupWin("searchForm", "/common/searchPopList.do","stock");
        }
    });
    $('#searchlocgrade').change(function(){
        var searchlocgb = $('#searchlocgb').val();

        var locgbparam = "";
        for (var i = 0 ; i < searchlocgb.length ; i++){
            if (locgbparam == ""){
                locgbparam = searchlocgb[i];
            }else{
                locgbparam = locgbparam +"∈"+searchlocgb[i];
            }
        }

        var param = {searchlocgb:locgbparam , grade:$('#searchlocgrade').val()}
        doGetComboData('/common/selectStockLocationList2.do', param , '', 'searchLoc', 'M','f_multiComboType');
    });

    $("#download").click(function() {
        GridCommon.exportTo("main_grid_wrap", 'xlsx', "Total Stcok List");
    });
    $("#searchBranch").change(function(){
        if(($('#searchlocgb').val() == "04") && ($('#searchBranch').val() != "")){
        	console.log("choose cody and branch is selected.");
        	var paramdata = {
        			searchBranch : $("#searchBranch").val(),
                    locgb : 'CT'
                };
            doGetComboData('/common/selectStockLocationList.do', paramdata , '', 'searchLoc', 'M','f_multiComboType');
        }
    });
});

function fn_PdfReport() {
    Common.popupDiv("/logistics/totalstock/totalStockPdfPop.do", null, null, true, '');
  }

function fn_ExcelReportCt() {
    Common.popupDiv("/logistics/totalstock/totalStockCtPop.do", null, null, true, '');
  }

function SearchSessionAjax() {
    var url = "/logistics/totalstock/SearchSessionInfo.do";
    Common.ajaxSync("GET" , url , '' , function(result){
        userCode=result.UserCode;
        $("#LocCode").val(userCode);
    });
}


function SearchListAjax() {
    var url = "/logistics/totalstock/totStockSearchList.do";
    var param = $('#searchForm').serialize();

    Common.ajax("GET" , url , param , function(data){
        AUIGrid.setGridData(listGrid, data.data);

    });
}

function f_validatation(){

             if ($("#searchlocgb").val() == null || $("#searchlocgb").val() == undefined || $("#searchlocgb").val() == ""){
                 Common.alert("Please Select Location Type.");
                 return false;
             }
             else {
                 return true;
             }
}

function f_multiCombo() {
    $(function() {
        $('#searchlocgb').change(function() {
            //console.log('1');
            if ($('#searchlocgb').val() != null && $('#searchlocgb').val() != "" ){
                 var searchlocgb = $('#searchlocgb').val();

                    var locgbparam = "";
                    for (var i = 0 ; i < searchlocgb.length ; i++){
                        if (locgbparam == ""){
                            locgbparam = searchlocgb[i];
                        }else{
                            locgbparam = locgbparam +"∈"+searchlocgb[i];
                        }
                    }
                    var param = {searchlocgb:locgbparam , grade:$('#searchlocgrade').val(),
                    		searchBranch: ($('#searchBranch').val()!="" ? $('#searchBranch').val() : "" )}
                    doGetComboData('/common/selectStockLocationList2.do', param , '', 'searchLoc', 'M','f_multiComboType');
              }
        })
         .multipleSelect({
            selectAll : true
        });
    });
}
function f_multiComboType() {
    $(function() {
        $('#searchType').change(function() {
        }).multipleSelect({
            selectAll : true
        });  /* .multipleSelect("checkAll"); */

        $('#searchLoc').change(function() {
        }).multipleSelect({
            selectAll : true
        });

    });
}
function f_multiCombos() {
    $(function() {
        $('#searchCtgry').change(function() {
        }).multipleSelect({
            selectAll : true
        }); /* .multipleSelect("checkAll"); */
    });
}

function fn_itempopList(data){

    var rtnVal = data[0].item;
    console.log(rtnVal);
    if ($("#stype").val() == "stock" ){
        $("#searchMatCode").val(rtnVal.itemcode);
        $("#searchMatName").val(rtnVal.itemname);
    }else{
        $("#searchLoc").val(rtnVal.locid);

    }

    $("#svalue").val();
}

function searchlocationFunc(){
    console.log('111');
}

// 시리얼 조회 팝업 호출
function fn_serialSearchPop(){

    Common.popupWin("frmSearchSerial", "/logistics/SerialMgmt/serialSearchPop.do", {width : "1000px", height : "580", resizable: "no", scrollbars: "no"});

}

function fnSerialSearchResult(data) {
    data.forEach(function(dataRow) {
//        console.log("serialNo : " + dataRow.serialNo);
    });
}
</script>

<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>logistics</li>
    <li>Total Stock List</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>Inventory By Location</h2>
</aside><!-- title_line end -->



<aside class="title_line"><!-- title_line start -->
<h3>Header Info</h3>
    <ul class="right_btns">
<c:if test="${PAGE_AUTH.funcView == 'Y'}">
      <li><p class="btn_blue"><a id="search"><span class="search"></span>Search</a></p></li>
</c:if>
      <li><p class="btn_blue"><a id="clear"><span class="clear"></span>Clear</a></p></li>
    </ul>
</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->
    <form id="searchForm" name="searchForm" method="post" onsubmit="return false;">
        <input type="hidden" id="sUrl" name="sUrl">
        <INPUT type="hidden" id="svalue" name="svalue">
        <INPUT type="hidden" id="stype" name="stype">
        <input type="hidden" name="LocCode" id="LocCode" />
        <table class="type1"><!-- table start -->
            <caption>search table</caption>
            <colgroup>
                <col style="width:140px" />
                <col style="width:*" />
                <col style="width:140px" />
                <col style="width:*" />
                <col style="width:140px" />
                <col style="width:*" />
            </colgroup>
            <tbody>
              <tr>
                   <th scope="row">Branch</th>
                   <td>
                   <select class="w100p" id="searchBranch"  name="searchBranch"></select>
                   <!-- <select id="searchlocgb" name="searchlocgb" class="multy_select w100p"multiple="multiple"></select> -->
                   </td>
                   <th scope="row">CDC</th>
                   <td>
                        <select class="w100p" id="searchCDC" name="searchCDC"></select>
                   </td>
                   <!-- <th scope="row"></th> -->
                   <td colspan="2">
                   </td>
                </tr>
                <tr>
                   <th scope="row">Location Type</th>
                   <td>
                        <select id="searchlocgb" name="searchlocgb" class="multy_select w100p"multiple="multiple"></select>
<!--                         <INPUT type="hidden" class="w100p" id="searchLoc" name="searchLoc"> -->
<!--                         <INPUT type="text"   class="w100p" id="searchLocNm" name="searchLocNm"> -->
                   </td>
                   <th scope="row">Location Grade</th>
                   <td>
                        <select class="w100p" id="searchlocgrade" name="searchlocgrade"></select>
                   </td>
                   <th scope="row">Location</th>
                   <td>
                        <select class="w100p" id="searchLoc" name="searchLoc" class="multy_select w100p"multiple="multiple"></select>
                   </td>
                </tr>
                <tr>
                   <th scope="row">Material Code/Name</th>
                   <td >
                      <input type="hidden" title="" placeholder=""  class="w100p" id="searchMatCode" name="searchMatCode"/>
                      <input type="text"   title="" placeholder=""  class="w100p" id="searchMatName" name="searchMatName"/>
                   </td>
                    <th scope="row">Category</th>
                   <td>
                       <select class="w100p" id="searchCtgry"  name="searchCtgry"></select>
                   </td>
                   <th scope="row">Type</th>
                   <td>
                       <select class="w100p" id="searchType" name="searchType"></select>
                   </td>
                </tr>

            </tbody>
        </table><!-- table end -->
        <aside class="link_btns_wrap">
    <!-- link_btns_wrap start -->
    <p class="show_btn">
     <a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a>
    </p>
    <dl class="link_list">
     <dt><spring:message code='sales.Link'/></dt>
     <dd>
      <ul class="btns">
      </ul>
      <ul class="btns">
        <li><p class="link_btn type2">
          <a href="#" onclick="fn_PdfReport()">Total Stock Report (PDF)</a>
         </p></li>
          <li>
                <p class="link_btn type2">
                    <a href="#" onclick="fn_ExcelReportCt()">Total Stock Report (CT)</a>
                </p>
         </li>
      </ul>
      <p class="hide_btn">
       <a href="#"><img
        src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif"
        alt="hide" /></a>
      </p>
     </dd>
    </dl>
   </aside>
   <!-- link_btns_wrap end -->
    </form>
    <form id="frmSearchSerial" name="frmSearchSerial" method="post">
        <input id="pGubun" name="pGubun" type="hidden" value="SEARCH" />
        <input id="pFixdYn" name="pFixdYn" type="hidden" value="N" />
        <input id="pLocationType" name="pLocationType" type="hidden" value="" />
        <input id="pLocationCode" name="pLocationCode" type="hidden" value="" />
        <input id="pItemCodeOrName" name="pItemCodeOrName" type="hidden" value="" />
        <input id="pStatus" name="pStatus" type="hidden" value="" />
        <input id="pSerialNo" name="pSerialNo" type="hidden" value="" />
    </form>
    </section><!-- search_table end -->

    <!-- data body start -->
    <section class="search_result"><!-- search_result start -->

        <ul class="right_btns">
<c:if test="${PAGE_AUTH.funcChange == 'Y'}">
            <li><p class="btn_grid"><a id="download"><spring:message code='sys.btn.excel.dw' /></a></p></li>
</c:if>
<!--          <li><p class="btn_grid"><a id="insert">INS</a></p></li>             -->
        </ul>

        <article class="grid_wrap"><!-- grid_wrap start -->
        <div id="main_grid_wrap" class="autoGridHeight"></div>
        </article><!-- grid_wrap end -->

    </section><!-- search_result end -->

</section>

