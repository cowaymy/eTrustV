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

var rescolumnLayout=[{dataField:    "rnum",headerText :"<spring:message code='log.head.rownum'/>",width:120    ,height:30 , visible:false},
                     {dataField: "status",headerText :"<spring:message code='log.head.status'/>",width:120    ,height:30 , visible:false},
                     {dataField: "reqstno",headerText :"STO No."           ,width:120    ,height:30                },
                     {dataField: "staname",headerText :"<spring:message code='log.head.status'/>",width:120    ,height:30                },
                     {dataField: "reqloc",headerText :"<spring:message code='log.head.fromlocation'/>"                  ,width:120    ,height:30 , visible:false},
                     {dataField: "reqlocnm",headerText :"<spring:message code='log.head.fromlocation'/>"                ,width:120    ,height:30 , visible:false},
                     {dataField: "rcvlocdesc",headerText :"<spring:message code='log.head.fromlocation'/>"                  ,width:120    ,height:30                },
                     {dataField: "rcvloc",headerText :"<spring:message code='log.head.tolocation'/>"                  ,width:120    ,height:30 , visible:false},
                     {dataField: "rcvlocnm",headerText :"<spring:message code='log.head.tolocation'/>"                    ,width:120    ,height:30 , visible:false},
                     {dataField: "reqlocdesc",headerText :"<spring:message code='log.head.tolocation'/>"                  ,width:120    ,height:30                },
                     {dataField: "itmcd",headerText :"<spring:message code='log.head.matcode'/>"                   ,width:120    ,height:30 , visible:true },
                     {dataField: "itmname",headerText :"Mat. Name"                 ,width:120    ,height:30                },
                     {dataField: "reqstqty",headerText :"<spring:message code='log.head.requestedqty'/>"                ,width:120    ,height:30                },
                     {dataField: "delvno",headerText :"<spring:message code='log.head.delvno'/>",width:120    ,height:30 , visible:false},
                     {dataField: "delyqty",headerText :"<spring:message code='log.head.deliveredqty'/>"                 ,width:120    ,height:30 },
                     {dataField: "reqstqty",headerText :"<spring:message code='log.head.giqty'/>"                 ,width:120    ,height:30 },
                     {dataField: "rciptqty",headerText :"<spring:message code='log.head.grqty'/>"           ,width:120    ,height:30                },
                     {dataField: "docno",headerText :"<spring:message code='log.head.refdocno'/>"              ,width:120    ,height:30                },
                     {dataField: "uom",headerText :"<spring:message code='log.head.unitofmeasure'/>"              ,width:120    ,height:30 , visible:false},
                     {dataField: "uomnm",headerText :"UOM"                ,width:120    ,height:30                },
                     {dataField: "reqitmno",headerText :"<spring:message code='log.head.stoitem'/>"                      ,width:120    ,height:30 , visible:false},
                     {dataField: "ttype",headerText :"<spring:message code='log.head.transactiontype'/>"             ,width:120    ,height:30 , visible:false},
                     {dataField: "ttext",headerText :"Trans. Type"        ,width:120    ,height:30                },
                     {dataField: "mtype",headerText :"<spring:message code='log.head.movementtype'/>"                   ,width:120    ,height:30 , visible:false},
                     {dataField: "mtext",headerText :"Movement Type"                   ,width:120    ,height:30                },
                     {dataField: "froncy",headerText :"<spring:message code='log.head.auto/manual'/>"                   ,width:120    ,height:30                },
                     {dataField: "crtdt",headerText :"Reqst. Create Date"            ,width:120    ,height:30                },
                     {dataField: "reqdate",headerText :"Reqst. Required Date"          ,width:120    ,height:30 ,visible:false},
                     {dataField: "userName",headerText :"Creator"        ,width:120    ,height:30 }
                     ];

var reqcolumnLayout = [{dataField:  "delyno",headerText :"<spring:message code='log.head.deliveryno'/>"                    ,width:120    ,height:30                },
                       {dataField: "ttype",headerText :"<spring:message code='log.head.transactiontype'/>"             ,width:120    ,height:30 , visible:false},
                       {dataField: "ttext",headerText :"<spring:message code='log.head.transactiontypetext'/>"        ,width:120    ,height:30                },
                       {dataField: "mtype",headerText :"<spring:message code='log.head.movementtype'/>"                   ,width:120    ,height:30 , visible:false},
                       {dataField: "mtext",headerText :"<spring:message code='log.head.movementtext'/>"                   ,width:120    ,height:30                },
                       {dataField: "rcvloc",headerText :"<spring:message code='log.head.fromlocation'/>"                  ,width:120    ,height:30 , visible:false},
                       {dataField: "rcvlocnm",headerText :"<spring:message code='log.head.fromlocation'/>"                ,width:120    ,height:30 , visible:false},
                       {dataField: "rcvlocdesc",headerText :"<spring:message code='log.head.fromlocation'/>"                  ,width:120    ,height:30                },
                       {dataField: "reqloc",headerText :"<spring:message code='log.head.tolocation'/>"                  ,width:120    ,height:30 , visible:false},
                       {dataField: "reqlocnm",headerText :"<spring:message code='log.head.tolocation'/>"                    ,width:120    ,height:30 , visible:false},
                       {dataField: "reqlocdesc",headerText :"<spring:message code='log.head.tolocation'/>"                  ,width:120    ,height:30                },
                       {dataField: "delydt",headerText :"<spring:message code='log.head.deliverydate'/>"                  ,width:120    ,height:30 },
                       {dataField: "gidt",headerText :"<spring:message code='log.head.gidate'/>"                        ,width:120    ,height:30 },
                       {dataField: "grdt",headerText :"<spring:message code='log.head.grdate'/>"                        ,width:120    ,height:30 },
                       {dataField: "itmcd",headerText :"<spring:message code='log.head.materialcode'/>"                   ,width:120    ,height:30 , visible:false},
                       {dataField: "itmname",headerText :"<spring:message code='log.head.materialname'/>"                 ,width:120    ,height:30                },
                       {dataField: "delyqty",headerText :"<spring:message code='log.head.deliveredqty'/>"                 ,width:120    ,height:30 },
                       {dataField: "rciptqty",headerText :"<spring:message code='log.head.goodreceiptedqty'/>"           ,width:120    ,height:30                },
                       {dataField: "reqstno",headerText :"<spring:message code='log.head.sto'/>"                            ,width:120    ,height:30},
                       {dataField: "uom",headerText :"<spring:message code='log.head.unitofmeasure'/>"              ,width:120    ,height:30 , visible:false},
                       {dataField: "uomnm",headerText :"<spring:message code='log.head.unitofmeasure'/>"                ,width:120    ,height:30                }];

var mtrcolumnLayout = [
						{dataField: "matrlDocNo",headerText :"<spring:message code='log.head.matrldocno'/>"  ,width:200    ,height:30},
						{dataField: "matrlDocItm",headerText :"<spring:message code='log.head.matrldocitm'/>"    ,width:120    ,height:30},
						{dataField: "trnscTypeCode",headerText :"<spring:message code='log.head.transfertype'/>"     ,width:120    ,height:30},
						{dataField: "invntryMovType",headerText :"<spring:message code='log.head.transfertypedtl'/>"     ,width:120    ,height:30},
						{dataField: "matrlDocYear",headerText :"<spring:message code='log.head.matrldocyear'/>"  ,width:120    ,height:30},
						{dataField: "autoCrtItm" ,headerText:    ""   ,width:120    ,height:30},
						{dataField: "debtCrditIndict",headerText :"<spring:message code='log.head.debtcrditindict'/>"    ,width:120    ,height:30},
						{dataField: "matrlNo",headerText :"<spring:message code='log.head.matrlno'/>"    ,width:120    ,height:30},
						{dataField: "itmName",headerText :"<spring:message code='log.head.matrlname'/>"  ,width:200    ,height:30},
						{dataField: "qty",headerText :"<spring:message code='log.head.qty'/>"    ,width:100    ,height:30},
						{dataField: "codeName"   ,headerText:    ""   ,width:120    ,height:30, visible:false},
						{dataField: "rqloc"  ,headerText:    ""   ,width:120    ,height:30, visible:false},
						{dataField: "rqlocid"    ,headerText:    ""   ,width:120    ,height:30, visible:false},
						 {dataField:    "delvryNo",headerText :"<spring:message code='log.head.deliveryno'/>"    ,width:200    ,height:30},
						 {dataField:    "itmCode",headerText :"<spring:message code='log.head.itmcode'/>"    ,width:120    ,height:30},
						 {dataField:    "stockTrnsfrReqst",headerText :"<spring:message code='log.head.reqno'/>"     ,width:120    ,height:30},
						 {dataField:    "rcloc"  ,headerText:    ""   ,width:120    ,height:30, visible:false},
						 {dataField:    "rclocid"    ,headerText:    ""   ,width:120    ,height:30, visible:false},
						 {dataField:    "rclocnm",headerText :"<spring:message code='log.head.from'/>"   ,width:200   ,height:30},
						 {dataField:    "rqlocnm",headerText :"<spring:message code='log.head.to'/>"     ,width:200   ,height:30},
						 {dataField:    "uom"    ,headerText:    ""   ,width:120    ,height:30 , visible:false},
						 {dataField:    "uomnm",headerText :"<spring:message code='log.head.uom'/>"  ,width:120    ,height:30}
           ];
//var resop = {usePaging : true,useGroupingPanel : true , groupingFields : ["reqstno"] ,displayTreeOpen : true, enableCellMerge : true, showBranchOnGrouping : false};
var resop = {
        rowIdField : "rnum",
        //editable : true,
        //groupingFields : ["reqstno", "staname"],
        displayTreeOpen : false,
        //showStateColumn : false,
        showBranchOnGrouping : false
        };
var reqop = {editable : false,usePaging : false ,showStateColumn : false};
var paramdata;

var amdata = [{"codeId": "A","codeName": "Auto"},{"codeId": "M","codeName": "Manaual"}];
var uomlist = f_getTtype('42' , '');
var paramdata;

/* Required Date 초기화 */
var date = new Date();
var getdate = date.getDate();
var datemonth = date.getMonth() + 1;
if(getdate < 10) {
    getdate = '0'+date.getDate();
}
if(datemonth < 10) {
	datemonth = '0' + datemonth;
}
today = getdate + '/' + datemonth + '/' + date.getFullYear();

var nextdate = date.setDate(date.getDate()+6);
var nextmonth = date.getMonth() + 1;
if(date.getDate() < 10) {
    getdate = '0'+date.getDate();
}
if(nextmonth < 10) {
	nextmonth = '0' + nextmonth;
}
nextdate = getdate + '/' + nextmonth + '/' + date.getFullYear();




$(document).ready(function(){
    /**********************************
    * Header Setting
    **********************************/
    paramdata = { groupCode : '306' , orderValue : 'CODE_ID' , Codeval:'US'};

    doGetComboData('/common/selectCodeList.do', paramdata, ('${searchVal.sttype}'==''?'US':'${searchVal.sttype}'),'sttype', 'S' , 'f_change');
    doGetComboData('/common/selectCodeList.do', {groupCode:'309'}, '${searchVal.sstatus}','sstatus', 'S' , '');
    doGetComboData('/logistics/stocktransfer/selectStockTransferNo.do', {groupCode:'stock'} , '${searchVal.streq}','streq', 'S' , '');
    doDefCombo(amdata, '${searchVal.sam}' ,'sam', 'S', '');
    $("#crtsdt").val('${searchVal.crtsdt}');
    $("#crtedt").val('${searchVal.crtedt}');
    $("#reqsdt").val(today);
    $("#reqedt").val(nextdate);

    /**********************************
     * Header Setting End
     ***********************************/

    listGrid = AUIGrid.create("#main_grid_wrap", rescolumnLayout, resop);
    subGrid  = GridCommon.createAUIGrid("#sub_grid_wrap", reqcolumnLayout ,"", reqop);
    mdcGrid  = GridCommon.createAUIGrid("#mdc_grid", mtrcolumnLayout ,"", reqop);
    $("#sub_grid_wrap").hide();
    $("#mdc_grid").hide();

    AUIGrid.bind(listGrid, "cellClick", function( event ) {
        $("#sub_grid_wrap").hide();
        $("#mdc_grid").hide();
        if (event.dataField == "reqstno"){
            SearchDeliveryListAjax(event.value)
        }
    });

    AUIGrid.bind(listGrid, "cellDoubleClick", function(event){

        $("#rStcode").val(AUIGrid.getCellValue(listGrid, event.rowIndex, "reqstno"));
        document.searchForm.action = '/logistics/stocktransfer/StocktransferView.do';
        document.searchForm.submit();

    });

    AUIGrid.bind(listGrid, "ready", function(event) {
    });


});

function f_change(){
	paramdata = { groupCode : '308' , orderValue : 'CODE_ID' , likeValue:$("#sttype").val(), codeIn:'US03,US93'};
    doGetComboData('/common/selectCodeList.do', paramdata, '${searchVal.smtype}','smtype', 'S' , '');
}
//btn clickevent
$(function(){
    $('#search').click(function() {
    	if(validation()) {
    		 SearchListAjax();
    	}
    });
    $('#clear').click(function() {
        $('#streq').val('');
        $('#tlocationnm').val('');
        $('#flocationnm').val('');
        $('#crtsdt').val('');
        $('#crtedt').val('');
        $('#reqsdt').val('');
        $('#reqedt').val('');
        $('#sstatus').val('');
        $('#sam').val('');
        $('#refdocno').val('');
    	paramdata = { groupCode : '308' , orderValue : 'CODE_ID' , likeValue:$("#sttype").val(),codeIn:'US03,US93'};
        doGetComboData('/common/selectCodeList.do', paramdata, '${searchVal.smtype}','smtype', 'S' , '');
    });
    $("#sttype").change(function(){
    });

    $("#download").click(function() {
        GridCommon.exportTo("main_grid_wrap", 'xlsx', "STO List");
    });

    $('#insert').click(function(){
        document.searchForm.action = '/logistics/stocktransfer/StocktransferIns.do';
        document.searchForm.submit();
    });
/*     $('#com_rmk_info').click(function(){
        mdcGrid  = GridCommon.createAUIGrid("#mdc_grid", reqcolumnLayout ,"", reqop);
    }); */
    $("#tlocationnm").keypress(function(event) {
    	$('#tlocation').val('');
        if (event.which == '13') {
            $("#stype").val('tlocation');
            $("#svalue").val($('#tlocationnm').val());
            $("#sUrl").val("/logistics/organization/locationCdSearch.do");

            Common.searchpopupWin("searchForm", "/common/searchPopList.do","location");
        }
    });
    $("#flocationnm").keypress(function(event) {
    	$('#flocation').val('');
        if (event.which == '13') {
            $("#stype").val('flocation');
            $("#svalue").val($('#flocationnm').val());
            $("#sUrl").val("/logistics/organization/locationCdSearch.do");

            Common.searchpopupWin("searchForm", "/common/searchPopList.do","location");
        }
    });

});

function fn_itempopList(data){

    var rtnVal = data[0].item;

    if ($("#stype").val() == "flocation" ){
        $("#flocation").val(rtnVal.locid);
        $("#flocationnm").val(rtnVal.locdesc);
    }else{
        $("#tlocation").val(rtnVal.locid);
        $("#tlocationnm").val(rtnVal.locdesc);
    }

    $("#svalue").val();
}

function validation() {
	if ($("#reqsdt").val() == '' ||$("#reqedt").val() == ''){
        Common.alert('Please enter Required Date.');
        return false;
    } else {
    	return true;
    }
}
function SearchListAjax() {

	if ($("#flocationnm").val() == ""){
		$("#flocation").val('');
	}
	if ($("#tlocationnm").val() == ""){
        $("#tlocation").val('');
    }

	if ($("#flocation").val() == ""){
        $("#flocation").val($("#flocationnm").val());
    }
    if ($("#tlocation").val() == ""){
        $("#tlocation").val($("#tlocationnm").val());
    }


    var url = "/logistics/stocktransfer/StocktransferSearchList.do";
    var param = $('#searchForm').serializeJSON();
    Common.ajax("POST" , url , param , function(data){
        AUIGrid.setGridData(listGrid, data.data);

    });
}

function SearchDeliveryListAjax( reqno ) {
    var url = "/logistics/stocktransfer/StocktransferRequestDeliveryList.do";
    var param = "reqstno="+reqno;
    $("#sub_grid_wrap").show();
    $("#mdc_grid").show();

    Common.ajax("GET" , url , param , function(data){
        AUIGrid.setGridData(subGrid, data.data);
        //mdcGrid  = GridCommon.createAUIGrid("#mdc_grid", reqcolumnLayout ,"", reqop);
        //AUIGrid.resize(mdcGrid,1620,150);
        AUIGrid.resize(mdcGrid,1876,191);
        AUIGrid.setGridData(mdcGrid, data.data2);

    });
}

function f_getTtype(g , v){
    var rData = new Array();
    $.ajax({
           type : "GET",
           url : "/common/selectCodeList.do",
           data : { groupCode : g , orderValue : 'CRT_DT' , likeValue:v},
           dataType : "json",
           contentType : "application/json;charset=UTF-8",
           async:false,
           success : function(data) {
              $.each(data, function(index,value) {
                  var list = new Object();
                  list.code = data[index].code;
                  list.codeId = data[index].codeId;
                  list.codeName = data[index].codeName;
                  rData.push(list);
                });
           },
           error: function(jqXHR, textStatus, errorThrown){
               alert("Draw ComboBox['"+obj+"'] is failed. \n\n Please try again.");
           },
           complete: function(){
           }
       });

    return rData;
}
</script>

<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>logistics</li>
    <li>STO List</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>STO List</h2>
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

        <!-- menu setting -->
        <input type="hidden" name="CURRENT_MENU_CODE" value="${param.CURRENT_MENU_CODE}"/>
        <input type="hidden" name="CURRENT_MENU_FULL_PATH_NAME" value="${param.CURRENT_MENU_FULL_PATH_NAME}"/>
        <!-- menu setting -->

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
                    <th scope="row">STO No</th>
                    <td>
                        <!-- <select class="w100p" id="streq" name="streq"></select> -->
                        <input type="text" class="w100p" id="streq" name="streq">
                    </td>
                    <th scope="row">Transfer Type</th>
                    <td>
                        <select class="w100p" id="sttype" name="sttype"></select>
                    </td>
                    <th scope="row">Movement Type</th>
                    <td>
                        <select class="w100p" id="smtype" name="smtype"><option value=''>Choose One</option></select>
                    </td>
                </tr>
                <tr>
                    <th scope="row">From Location</th>
                    <td>
                        <input type="hidden"  id="tlocation" name="tlocation">
                        <input type="text" class="w100p" id="tlocationnm" name="tlocationnm">
                    </td>
                    <th scope="row">To Location</th>
                    <td >
                        <input type="hidden"  id="flocation" name="flocation">
                        <input type="text" class="w100p" id="flocationnm" name="flocationnm">
                    </td>
                    <th scope="row">Ref Doc.No </th>
                    <td>
                        <input type="text" class="w100p" id="refdocno" name="refdocno">
                    </td>
                </tr>

                <tr>
                    <th scope="row">Create Date</th>
                    <td>
                        <div class="date_set w100p"><!-- date_set start -->
                        <p><input id="crtsdt" name="crtsdt" type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date"></p>
                        <span> To </span>
                        <p><input id="crtedt" name="crtedt" type="text" title="Create End Date" placeholder="DD/MM/YYYY" class="j_date"></p>
                        </div><!-- date_set end -->
                    </td>
                    <th scope="row">Required Date</th>
                    <td >
                        <div class="date_set w100p"><!-- date_set start -->
                        <p><input id="reqsdt" name="reqsdt" type="text" title="Create start Date" value="${searchVal.reqsdt}" placeholder="DD/MM/YYYY" class="j_date"></p>
                        <span> To </span>
                        <p><input id="reqedt" name="reqedt" type="text" title="Create End Date" value="${searchVal.reqedt}" placeholder="DD/MM/YYYY" class="j_date"></p>
                        </div><!-- date_set end -->
                    </td>
                    <td colspan="2">&nbsp;</td>
                </tr>

                <tr>
                    <th scope="row">Status</th>
                    <td>
                        <select class="w100p" id="sstatus" name="sstatus"></select>
                    </td>
                    <th scope="row">Auto / Manual</th>
                    <td>
                        <select class="w100p" id="sam" name="sam"></select>
                    </td>
                    <td colspan="2">&nbsp;</td>
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
<c:if test="${PAGE_AUTH.funcChange == 'Y'}">
            <li><p class="btn_grid"><a id="insert">New</a></p></li>
</c:if>
        </ul>
        <div id="main_grid_wrap" class="mt10" style="height:450px"></div>

<!--         <div id="sub_grid_wrap" class="mt10" style="height:350px"></div> -->

    </section><!-- search_result end -->
    <section class="tap_wrap"><!-- tap_wrap start -->
        <ul class="tap_type1">
            <li><a href="#" class="on">Delivery No Info</a></li>
            <li><a href="#">Material Document Info</a></li>
        </ul>

        <article class="tap_area"><!-- tap_area start -->

            <article class="grid_wrap"><!-- grid_wrap start -->
                  <div id="sub_grid_wrap" class="mt10" style="height:150px"></div>
            </article><!-- grid_wrap end -->

        </article><!-- tap_area end -->

        <article class="tap_area"><!-- tap_area start -->
            <article class="grid_wrap"><!-- grid_wrap start -->
                 <div id="mdc_grid"  class="mt10" ></div>
            </article><!-- grid_wrap end -->
        </article><!-- tap_area end -->

    </section><!-- tap_wrap end -->
</section>

