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

</style>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery.blockUI.min.js"></script>
<script type="text/javaScript" language="javascript">
var listGrid;
var subGrid;
var mdcGrid;
var myGridID;
var detailGridID;


// AUIGrid 칼럼 설정                                                                            visible : false
var columnLayout = [{dataField: "matrlNo",headerText :"<spring:message code='log.head.matcode'/>"                ,width:120    ,height:30 , visible:true},
							{dataField: "stkDesc",headerText :"Material Name"           ,width:120    ,height:30 , visible:true},
							{dataField: "reqStorgNm",headerText :"From SLoc"                     ,width:120    ,height:30 , visible:true},
							{dataField: "revStorgNm",headerText :"To SLoc"                     ,width:120    ,height:30 , visible:true},
							{dataField: "trantype",headerText :"<spring:message code='log.head.transactiontype'/>"        ,width:120    ,height:30 , visible:true},
							{dataField: "invntryMovType",headerText :"<spring:message code='log.head.movementtype'/>"                   ,width:120    ,height:30 , visible:true},
							{dataField: "movtype",headerText :"<spring:message code='log.head.movementtext'/>"                ,width:120    ,height:30 , visible:true},
							{dataField: "qty",headerText :"<spring:message code='log.head.qty'/>"                           ,width: "8%"       ,height:30 , visible:true},
							{dataField: "matrlDocNo",headerText :"Mat. Doc No."           ,width:120    ,height:30 , visible:true},
							{dataField: "matrlDocItm",headerText :"Mat. Doc Item"                         ,width:120    ,height:30 , visible:true},
							{dataField: "postingdate",headerText :"<spring:message code='log.head.postingdate'/>"                  ,width:120    ,height:30 , visible:true},
							{dataField: "delvryNo",headerText :"<spring:message code='log.head.deliveryno'/>"                   ,width:120    ,height:30 , visible:true},
							{dataField: "refDocNo",headerText :"<spring:message code='log.head.refdocno'/>"                 ,width:120    ,height:30 , visible:true},
							{dataField: "stockTrnsfrReqst",headerText :"<spring:message code='log.head.requestno'/>"                    ,width:120    ,height:30 , visible:true},
							{dataField: "debtCrditIndict",headerText :"<spring:message code='log.head.debit/credit'/>"                 ,width:120    ,height:30 , visible:true},
							{dataField: "autoCrtItm",headerText :"<spring:message code='log.head.auto/manual'/>"                    ,width:120    ,height:30 , visible:true},
							{dataField: "codeName",headerText :"<spring:message code='log.head.uom'/>"                ,width: "15%"     ,height:30 , visible:true},
							{dataField: ""  ,headerText:    ""                             ,width:  "15%"     ,height:30 , visible:false},
							{dataField: "dcfreqapproveremark",headerText :"<spring:message code='log.head.dcfreqapproveremark'/>"           ,width: "15%"     ,height:30 , visible:false},
							{dataField: "dcfreqapproveby",headerText :"<spring:message code='log.head.dcfreqapproveby'/>"               ,width: "15%"     ,height:30 , visible:false},
							{dataField: "reasondesc1",headerText :"<spring:message code='log.head.reason(approververified)'/>"   ,width:    "15%"     ,height:30 , visible:false},
							{dataField: "c7",headerText :"<spring:message code='log.head.approvalstatus'/>"             ,width: "15%"     ,height:30 , visible:false},
							{dataField: "c2",headerText :"<spring:message code='log.head.approveat'/>"                   ,width:    "15%"     ,height:30 , visible:false},
							{dataField: "dcfreqstatusid",headerText :"<spring:message code='log.head.dcf_req_stus_id'/>"                ,width: "15%"     ,height:30 , visible:false},
							{dataField: "salesOrdNo",headerText :"Ref.DOC.no_2"                ,width: "15%"     ,height:30 , visible:true},
							{dataField: "userName",headerText :"Creator"        ,width:120    ,height:30 }
                   ];

var resop = {
        rowIdField : "rnum",
        //editable : true,
        groupingFields : ["reqstno", "staname"],
        displayTreeOpen : true,
        enableCellMerge : true,
        //showStateColumn : false,
        showBranchOnGrouping : false
        };
var reqop = {editable : false,usePaging : false ,showStateColumn : false};
var gridoptions = {showStateColumn : false , editable : false, usePaging : false, useGroupingPanel : false };
var paramdata;

var amdata = [{"codeId": "A","codeName": "Auto"},{"codeId": "M","codeName": "Manaual"}];
var paramdata;
$(document).ready(function(){

    // masterGrid 그리드를 생성합니다.
    myGridID = GridCommon.createAUIGrid("main_grid_wrap", columnLayout,"", gridoptions);

    /**********************************
    * Header Setting
    **********************************/
    paramdata = { groupCode : '306' , orderValue : 'CRT_DT' , likeValue:''};

    CommonCombo.make("searchTrcType", "/common/selectCodeList.do", { groupCode : '306' , orderValue : 'CRT_DT' , likeValue:''}, "", {
        id: "code",
        name: "codeName",
        type:"M"
    });
    CommonCombo.make("searchMoveType", "/common/selectCodeList.do", { groupCode : '308' , orderValue : 'CODE_ID' , likeValue:''}, "", {
        id: "code",
        name: "codeName",
        type:"M",
        isCheckAll:false
    });
    doGetComboData('/common/selectCodeList.do', { groupCode : 339 , orderValue : 'CODE'}, '', 'sfrLoctype', 'M','f_frloctype');
    doGetComboData('/common/selectCodeList.do', { groupCode : 339 , orderValue : 'CODE'}, '', 'stoLoctype', 'M','f_toloctype');

    doGetComboData('/common/selectCodeList.do', { groupCode : 383 , orderValue : 'CODE'}, '', 'sfrLocgrade', 'A','');
    doGetComboData('/common/selectCodeList.do', { groupCode : 383 , orderValue : 'CODE'}, '', 'stoLocgrade', 'A','');

    doGetCombo('/common/selectCodeList.do', '15', '', 'smattype', 'M' ,'f_multiCombos');
    doGetCombo('/common/selectCodeList.do', '11', '', 'smatcate', 'M' ,'f_multiCombos');

    doDefCombo(amdata, 'M' ,'sam', 'S', '');

//     CommonCombo.make("sfrLoctype", "/common/selectCodeList.do", { groupCode : 339 , orderValue : 'CODE'}, "", {
//         id: "code",
//         name: "codeName",
//         type:"M"
//     });
//     CommonCombo.make("stoLoctype", "/common/selectCodeList.do", { groupCode : 339 , orderValue : 'CODE'}, "", {
//         id: "code",
//         name: "codeName",
//         type:"M",
//         isEnable:false
//     });
//     CommonCombo.make("sfrLoctype", "/common/selectCodeList.do", { groupCode : 339 , orderValue : 'CODE'}, "", {
//         id: "code",
//         name: "codeName",
//         type:"M"
//     });
//     CommonCombo.make("stoLoctype", "/common/selectCodeList.do", { groupCode : 339 , orderValue : 'CODE'}, "", {
//         id: "code",
//         name: "codeName",
//         type:"M"
//     });

    //doGetComboData('/common/selectCodeList.do', paramdata, '','searchTrcType', 'S' , '');
    //doGetComboData('/common/selectCodeList.do', {groupCode:'309'}, '','sstatus', 'S' , '');
//     doGetCombo('/common/selectStockLocationList.do', '', '','searchFromLoc', 'S' , 'SearchListAjax');//From Location 조회
//     doGetCombo('/common/selectStockLocationList.do', '', '','searchToLoc', 'S' , '');//To Location 조회


    AUIGrid.bind(myGridID, "cellClick", function( event ) {

    });

    AUIGrid.bind(listGrid, "cellDoubleClick", function(event){

    });

    AUIGrid.bind(listGrid, "ready", function(event) {
    });

    var today = new Date();
    var dd = today.getDate();
    var mm = today.getMonth()+1;
    var yyyy = today.getFullYear();

    if(dd<10) { dd='0'+dd; }

    if(mm<10) { mm='0'+mm; }

    $("#PostingDt1").val(dd + '/' + mm + '/' + yyyy);

    var today2 = new Date();
    today2.setDate(today2.getDate() + 6);
    var dd2 = today2.getDate();
    var mm2 = today2.getMonth() + 1;
    var yyyy2 = today2.getFullYear();

    if(dd2 < 10) { dd2 = '0' + dd2; }

    if(mm2 < 10) { mm2 ='0' + mm2; }

    $("#PostingDt2").val(dd2 + '/' + mm2 + '/' + yyyy2);
});


$(function(){
    $("#search").click(function() {
        SearchListAjax();
    });
    $("#clear").click(function() {

    });

    $("#download").click(function() {
    	GridCommon.exportTo("main_grid_wrap", 'xlsx', "Materia Document List");
    });

    $("#searchTrcType").change(function(){

    	CommonCombo.make("searchMoveType", "/logistics/materialDoc/selectTrntype.do", $("#searchForm").serialize(), "", {
            id: "code",
            name: "codeName",
            type:"M",
            isCheckAll:false
        });
    });
    $("#searchMaterialCode").keypress(function(event) {
        if (event.which == '13') {
            $("#stype").val('stock');
            $("#svalue").val($('#searchMaterialCode').val());
            $("#sUrl").val("/logistics/material/materialcdsearch.do");
            Common.searchpopupWin("searchForm", "/common/searchPopList.do","stock");
        }
    });
    $('#sfrLocgrade').change(function(){
    	var searchlocgb = $('#sfrLoctype').val();

        var locgbparam = "";
        for (var i = 0 ; i < searchlocgb.length ; i++){
            if (locgbparam == ""){
                locgbparam = searchlocgb[i];
            }else{
                locgbparam = locgbparam +"∈"+searchlocgb[i];
            }
        }

        var param = {searchlocgb:locgbparam , grade:$('#sfrLocgrade').val()}

        doGetComboData('/common/selectStockLocationList2.do', param , '', 'sfrLoc', 'M','f_multiComboType');
    });
    $('#stoLocgrade').change(function(){
        var searchlocgb = $('#stoLoctype').val();

        var locgbparam = "";
        for (var i = 0 ; i < searchlocgb.length ; i++){
            if (locgbparam == ""){
                locgbparam = searchlocgb[i];
            }else{
                locgbparam = locgbparam +"∈"+searchlocgb[i];
            }
        }

        var param = {searchlocgb:locgbparam , grade:$('#stoLocgrade').val()}

        doGetComboData('/common/selectStockLocationList2.do', param , '', 'stoLoc', 'M','f_multiComboType');
    });
});

function f_frloctype() {
    $(function() {
        $('#sfrLoctype').change(function() {
            if ($('#sfrLoctype').val() != null && $('#sfrLoctype').val() != "" ){
                 var searchlocgb = $('#sfrLoctype').val();

                    var locgbparam = "";
                    for (var i = 0 ; i < searchlocgb.length ; i++){
                        if (locgbparam == ""){
                            locgbparam = searchlocgb[i];
                        }else{
                            locgbparam = locgbparam +"∈"+searchlocgb[i];
                        }
                    }

                    var param = {searchlocgb:locgbparam , grade:$('#sfrLocgrade').val()}

                    doGetComboData('/common/selectStockLocationList2.do', param , '', 'sfrLoc', 'M','f_multiComboType');
              }
        }).multipleSelect({
            selectAll : true
        });
    });
}

function f_toloctype() {
    $(function() {
        $('#stoLoctype').change(function() {

            if ($('#stoLoctype').val() != null && $('#stoLoctype').val() != "" ){
                 var searchlocgb = $('#stoLoctype').val();

                    var locgbparam = "";
                    for (var i = 0 ; i < searchlocgb.length ; i++){
                        if (locgbparam == ""){
                            locgbparam = searchlocgb[i];
                        }else{
                            locgbparam = locgbparam +"∈"+searchlocgb[i];
                        }
                    }

                    var param = {searchlocgb:locgbparam , grade:$('#stoLocgrade').val()}
                    doGetComboData('/common/selectStockLocationList2.do', param , '', 'stoLoc', 'M','f_multiComboType');
              }
        }).multipleSelect({
            selectAll : true
        });
    });
}


function f_multiComboType() {
    $(function() {
        $('#sfrLoc').change(function() {
        }).multipleSelect({
            selectAll : true
        });  /* .multipleSelect("checkAll"); */
        $('#stoLoc').change(function() {
        }).multipleSelect({
            selectAll : true
        });
    });
}

function f_multiCombos() {
    $(function() {
        $('#smattype').change(function() {
        }).multipleSelect({
            selectAll : true
        }); /* .multipleSelect("checkAll"); */
        $('#smatcate').change(function() {
        }).multipleSelect({
            selectAll : true
        }); /* .multipleSelect("checkAll"); */
    });
}


	function fn_itempopList(data) {

		var rtnVal = data[0].item;

		$("#searchMaterialCode").val(rtnVal.itemcode);

		$("#svalue").val('');
	}

	function SearchListAjax() {

		var url = "/logistics/materialDoc/MaterialDocSearchList.do";
		var param = $('#searchForm').serialize();

		if($("#PostingDt1").val() == null || $("#PostingDt1").val() == "" )
		{
			Common.alert("Please input a 'From Posting Date'");
		}
		else if($("#PostingDt2").val() == null || $("#PostingDt2").val() == "" )
        {
            Common.alert("Please input a 'To Posting Date'");
        }
		else
		{

			Common.ajax("GET", url, param, function(data) {
				console.log(data);
				AUIGrid.setGridData(myGridID, data.data);

			});
		}
	}
</script>

<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>logistics</li>
    <li>Stock Movement Request List</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>Material Document No.</h2>

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
        <input type="hidden" id="svalue" name="svalue"/>
        <input type="hidden" id="sUrl"   name="sUrl"  />
        <input type="hidden" id="stype"  name="stype" />
        <input type="hidden" name="rStcode" id="rStcode" />
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
                    <th scope="row">Transaction Type</th>
                    <td>
                        <select id="searchTrcType" name="searchTrcType" class="multy_select w100p" multiple="multiple"></select>
                    </td>
                    <th scope="row">Movement Type</th>
                    <td>
                        <select id="searchMoveType" name="searchMoveType" class="multy_select w100p" multiple="multiple"></select>
                    </td>
                   <!--  <td colspan="2">&nbsp;</td> -->
                    <th scope="row">Mat. Doc</th>
                     <td>
                        <input type="text" id="searchMaterialDoc" name="searchMaterialDoc" title="" class="w100p" />
                    </td>
                </tr>
                <tr>
                    <th scope="row">Posting Date</th>
                    <td>
                        <div class="date_set w100p"><!-- date_set start -->
                        <p><input id="PostingDt1" name="PostingDt1" type="text" title="Posting Start Date" placeholder="DD/MM/YYYY" class="j_date"></p>
                        <span> To </span>
                        <p><input id="PostingDt2" name="PostingDt2" type="text" title="Posting End Date" placeholder="DD/MM/YYYY" class="j_date"></p>
                        </div><!-- date_set end -->
                    </td>
                    <th scope="row">Create Date</th>
                    <td >
                        <div class="date_set w100p"><!-- date_set start -->
                        <p><input id="CreateDt1" name="CreateDt1" type="text" title="Create Start Date"  placeholder="DD/MM/YYYY" class="j_date"></p>
                        <span> To </span>
                        <p><input id="CreateDt2" name="CreateDt2" type="text" title="Create End Date" placeholder="DD/MM/YYYY" class="j_date"></p>
                        </div><!-- date_set end -->
                    </td>
                    <th scope="row">Auto / Manual</th>
                    <td>
                        <select class="w100p" id="sam" name="sam"></select>
                    </td>
                </tr>
                <tr>
                    <th scope="row">From Location Type</th>
                    <td>
                        <select id="sfrLoctype" name="sfrLoctype" class="multy_select w100p" multiple="multiple"></select>
                    </td>
                    <th scope="row">From Location Grade</th>
                    <td>
                        <select id="sfrLocgrade" name="sfrLocgrade" class="select w100p"></select>
                    </td>
                    <th scope="row">From Location</th>
                    <td>
                        <select id="sfrLoc" name="sfrLoc" class="multy_select w100p" multiple="multiple"><option>Choose Type OR Grade</option></select>
                    </td>
                </tr>
                <tr>
                    <th scope="row">To Location Type</th>
                    <td>
                        <select id="stoLoctype" name="stoLoctype" class="multy_select w100p" multiple="multiple"></select>
                    </td>
                    <th scope="row">To Location Grade</th>
                    <td>
                        <select id="stoLocgrade" name="stoLocgrade" class="select w100p"></select>
                    </td>
                    <th scope="row">To Location</th>
                    <td>
                        <select id="stoLoc" name="stoLoc" class="multy_select w100p" multiple="multiple"></select>
                    </td>
                </tr>
                <tr>
                    <th scope="row">Material Code</th>
                    <td>
                        <input type="text" id="searchMaterialCode" name="searchMaterialCode" title="" placeholder="Material Code" class="w100p" />
                    </td>
                    <th scope="row">Material Type</th>
                    <td>
                        <select id="smattype" name="smattype" class="multy_select w100p" multiple="multiple"></select>
                    </td>
                    <th scope="row">Material Category</th>
                    <td>
                        <select id="smatcate" name="smatcate" class="multy_select w100p" multiple="multiple"></select>
                    </td>
                </tr>
                <tr>
                    <th scope="row">Ref.Doc No</th>
                    <td>
                        <input type="text" id="sdocno" name="sdocno" title="" placeholder="Material Document No" class="w100p" />
                    </td>
                    <th scope="row">Request No</th>
                    <td>
                        <input type="text" id="sreqstno" name="sreqstno" title="" placeholder="Request No" class="w100p" />
                    </td>
                    <th scope="row">Delivery No</th>
                    <td>
                        <input type="text" id="sdelvno" name="sdelvno" title="" placeholder="Delivery No" class="w100p" />
                    </td>
                </tr>
                 <tr>
                    <th scope="row">Ref.DOC.no_2</th>
                    <td>
                        <input type="text" id="sordno" name="sordno" title="" placeholder="Material Document No" class="w100p" />
                    </td>
                    <th scope="row"></th>
                    <td>
                        
                    </td>
                    <th scope="row"></th>
                    <td>
                        
                    </td>
                </tr>
            </tbody>
        </table><!-- table end -->
    </form>

    </section><!-- search_table end -->

    <!-- data body start -->
    <section class="search_result"><!-- search_result start -->
        <ul class="right_btns">
<c:if test="${PAGE_AUTH.funcPrint == 'Y'}">
            <li><p class="btn_grid"><a id="download"><spring:message code='sys.btn.excel.dw' /></a></p></li>
</c:if>
            <!-- <li><p class="btn_grid"><a id="insert">INS</a></p></li> -->
        </ul>

        <div id="main_grid_wrap" class="mt10" style="height:400px"></div>

    <!--    <div id="sub_grid_wrap" class="mt10" style="height:350px"></div>  -->

    </section><!-- search_result end -->

</section>

