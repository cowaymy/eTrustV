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
var listGrid;
var subGrid;

var rescolumnLayout=[
							{dataField: "rnum",headerText :"<spring:message code='log.head.rnum'/>" ,width:120 ,height:30,editable:false, visible:false},
							{dataField: "whLocId",headerText :"<spring:message code='log.head.whlocid'/>"   ,width:120 ,height:30,editable:false, visible:false},
							{dataField: "whLocCode",headerText :"<spring:message code='log.head.whloccode'/>"   ,width:120 ,height:30,editable:false, visible:false},
							{dataField: "whLocDesc",headerText :"<spring:message code='log.head.port'/>"    ,width:250 ,height:30,editable:false
                              ,cellMerge : true  },
                              {dataField: "plant",headerText :"<spring:message code='log.head.plant'/>"   ,width:120 ,height:30,editable:false, visible:false},
                              {dataField: "blNo",headerText :"<spring:message code='log.head.blno'/>" ,width:200 ,height:30,editable:false,
                              cellMerge : true,
                              mergeRef : "whLocDesc", // 이전 칼럼(대분류) 셀머지의 값을 비교해서 실행함. (mergePolicy : "restrict" 설정 필수)
                              mergePolicy : "restrict"     },
                              {dataField: "itmSeq",headerText :"<spring:message code='log.head.seq'/>"    ,width:80 ,height:30,editable:false},
                              {dataField: "stkid",headerText :"<spring:message code='log.head.stkid'/>"   ,width:120 ,height:30,editable:false, visible:false},
                              {dataField: "matrlNo",headerText :"<spring:message code='log.head.materialcd'/>"    ,width:140 ,height:30,editable:false},
                              {dataField: "stkTypeId",headerText :"<spring:message code='log.head.stktypeid'/>"   ,width:120 ,height:30,editable:false, visible:false},
                              {dataField: "stkdesc",headerText :"<spring:message code='log.head.material'/>"  ,width:250,height:30,editable:false},
                              {dataField: "uom",headerText :"<spring:message code='log.head.uom'/>"   ,width:120 ,height:30,editable:false, visible:false},
                              {dataField: "uomnm",headerText :"<spring:message code='log.head.uom'/>" ,width:120 ,height:30,editable:false},
                              {dataField: "typename",headerText :"<spring:message code='log.head.type'/>" ,width:120 ,height:30,editable:false},
                              {dataField: "stkCtgryId",headerText :"<spring:message code='log.head.stkctgryid'/>" ,width:120 ,height:30,editable:false, visible:false},
                              {dataField: "ctgryname",headerText :"<spring:message code='log.head.catagory'/>"    ,width:120 ,height:30,editable:false},
                              {dataField: "qty",headerText :"<spring:message code='log.head.blqty'/>" ,width:100 ,height:30,editable:false,dataType :     "numeric"   ,style: "aui-grid-user-custom-right"    },
                              {dataField: "avrqty",headerText :"<spring:message code='log.head.remainqty'/>"  ,width:100 ,height:30,editable:false ,dataType :    "numeric"   ,style: "aui-grid-user-custom-right"    },
                              {dataField: "reqedQty",headerText :"<spring:message code='log.head.movedqty'/>" ,width:100 ,height:30,editable:false ,dataType :    "numeric"   ,style: "aui-grid-user-custom-right"    },
                              {dataField: "reqQty",headerText :"<spring:message code='log.head.reqqty'/>" ,width:100 ,height:30,dataType :    "numeric"   ,style: "aui-grid-user-custom-right"    },
                              {dataField: "shipDt",headerText :"B/L Date"    ,width:120 ,height:30,editable:false},
                              {dataField: "grDt",headerText :"GR Date"    ,width:120 ,height:30,editable:false},
                              {dataField: "apCmplt",headerText :"<spring:message code='log.head.apcomplete'/>"    ,width:100 ,height:30,editable:false},
                              {dataField: "grCmplt",headerText :"<spring:message code='log.head.grcomplete'/>"    ,width:100 ,height:30,editable:false},
                              {dataField: "purDocNo",headerText :"<spring:message code='log.head.pono'/>"    ,width:180 ,height:30,editable:false},
                              {dataField: "accNo",headerText :"<spring:message code='log.head.vendorno'/>"    ,width:150 ,height:30,editable:false}
							];

var smoLayout=[
					{dataField: "reqstNo",headerText :"<spring:message code='log.head.reqstno'/>"   ,width:200 ,height:30},
					{dataField: "trnscType",headerText :"<spring:message code='log.head.trnsctype'/>"   ,width:120 ,height:30},
					{dataField: "trnscTypeDtl",headerText :"<spring:message code='log.head.trnsctypedtl'/>" ,width:120 ,height:30},
					{dataField: "pridicFrqncy",headerText :"<spring:message code='log.head.pridicfrqncy'/>" ,width:120 ,height:30, visible:false},
					{dataField: "reqstCrtDt",headerText :"<spring:message code='log.head.reqstcrtdt'/>" ,width:120 ,height:30},
					{dataField: "reqstRequireDt",headerText :"<spring:message code='log.head.reqstrequiredt'/>" ,width:120 ,height:30, visible:false},
					{dataField: "refDocNo",headerText :"<spring:message code='log.head.refdocno'/>" ,width:120 ,height:30, visible:false},
					{dataField: "docHderTxt",headerText :"<spring:message code='log.head.dochdertxt'/>" ,width:120 ,height:30, visible:false},
					{dataField: "goodsRcipt",headerText :"<spring:message code='log.head.goodsrcipt'/>" ,width:120 ,height:30, visible:false},
					{dataField: "rcivCdcRdc",headerText :"<spring:message code='log.head.rcivcdcrdc'/>" ,width:120 ,height:30, visible:false},
					{dataField: "rcivCdcRdc2",headerText :"<spring:message code='log.head.from'/>"  ,width:200 ,height:30},
					{dataField: "reqstCdcRdc",headerText :"<spring:message code='log.head.reqstcdcrdc'/>"   ,width:120 ,height:30, visible:false},
					{dataField: "reqstCdcRdc2",headerText :"<spring:message code='log.head.to'/>"   ,width:200 ,height:30},
					{dataField: "reqstRem",headerText :"<spring:message code='log.head.reqstrem'/>" ,width:120 ,height:30, visible:false},
					{dataField: "retnDefectResn",headerText :"<spring:message code='log.head.retndefectresn'/>" ,width:120 ,height:30, visible:false},
					{dataField: "retnPrsnCtCody",headerText :"<spring:message code='log.head.retnprsnctcody'/>" ,width:120 ,height:30, visible:false},
					{dataField: "crtUserId"  ,headerText:    ""  ,width:120 ,height:30, visible:false},
					{dataField: "crtDt",headerText :"<spring:message code='log.head.crtdt'/>"   ,width:120 ,height:30, visible:false},
					{dataField: "reqstStus",headerText :"<spring:message code='log.head.reqststus'/>"   ,width:120 ,height:30, visible:false},
					{dataField: "reqstDel",headerText :"<spring:message code='log.head.reqstdel'/>" ,width:120 ,height:30, visible:false},
					{dataField: "reqstType",headerText :"<spring:message code='log.head.reqsttype'/>"   ,width:120 ,height:30, visible:false},
					{dataField: "reqstTypeDtl",headerText :"<spring:message code='log.head.reqsttypedtl'/>" ,width:120 ,height:30, visible:false},
					{dataField: "reqstNoItm",headerText :"<spring:message code='log.head.reqstnoitm'/>" ,width:120 ,height:30},
					{dataField: "itmCode",headerText :"<spring:message code='log.head.itmcode'/>"   ,width:120 ,height:30},
					{dataField: "itmName",headerText :"<spring:message code='log.head.itmname'/>"   ,width:120 ,height:30},
					{dataField: "reqstQty",headerText :"<spring:message code='log.head.reqstqty'/>" ,width:120 ,height:30},
					{dataField: "uom",headerText :"<spring:message code='log.head.uom'/>"   ,width:120 ,height:30, visible:false},
					{dataField: "uomname",headerText :"<spring:message code='log.head.uom'/>"   ,width:120 ,height:30},
					{dataField: "itmTxt",headerText :"<spring:message code='log.head.itmtxt'/>" ,width:120 ,height:30, visible:false},
					{dataField: "finalCmplt",headerText :"<spring:message code='log.head.finalcmplt'/>" ,width:120 ,height:30, visible:false},
					{dataField: "crtUserId",headerText :"<spring:message code='log.head.userid'/>"  ,width:120 ,height:30},
					{dataField: "crtDt",headerText :"<spring:message code='log.head.crtdt'/>"   ,width:120 ,height:30, visible:false},
					{dataField: "updUserId",headerText :"<spring:message code='log.head.upduserid'/>"   ,width:120 ,height:30, visible:false},
					{dataField: "updDt",headerText :"<spring:message code='log.head.upddt'/>"   ,width:120 ,height:30, visible:false},
					{dataField: "rciptQty",headerText :"<spring:message code='log.head.rciptqty'/>" ,width:120 ,height:30, visible:false},
					{dataField: "blNo",headerText :"<spring:message code='log.head.blno'/>" ,width:120 ,height:30}
                     ];
var reqop = {
					showRowCheckColumn : true ,
					editable : true,
					usePaging : false ,
					showStateColumn : false
		         };
var smoop = {
					editable : false,
					usePaging : false ,
					showStateColumn : false
		         };

$(document).ready(function(){

   doGetCombo('/logistics/inbound/InboundLocation', 'port', '','location', 'S' , '');
   listGrid = AUIGrid.create("#main_grid_wrap", rescolumnLayout, reqop);
   subGrid  = AUIGrid.create("#sub_grid_wrap", smoLayout, smoop);

   doGetCombo('/common/selectCodeList.do', '15', '', 'smattype', 'M' ,'f_multiCombos');
   doGetCombo('/common/selectCodeList.do', '11', '', 'smatcate', 'M' ,'f_multiCombos');

    AUIGrid.bind(listGrid, "cellClick", function( event ) {
    });
    AUIGrid.bind(listGrid, "cellEditBegin", function (event){
    	  if (AUIGrid.getCellValue(listGrid, event.rowIndex, "avrqty") <= 0){
              Common.alert('Req Qty can not be greater than Available Qty.');
              return false;
          }
    });
    AUIGrid.bind(listGrid, "cellEditEnd", function( event ) {
    	if (event.dataField != "reqQty"){
            return false;
        }else{

            var del = AUIGrid.getCellValue(listGrid, event.rowIndex, "reqQty");
            if (del > 0){
                if ((Number(AUIGrid.getCellValue(listGrid, event.rowIndex, "avrqty")) < Number(AUIGrid.getCellValue(listGrid, event.rowIndex, "reqQty")))){
                	Common.alert('Req Qty can not be greater than Remain Qty.');
                    AUIGrid.restoreEditedRows(listGrid, "selectedIndex");
                }else{

			    	 var rnum = AUIGrid.getCellValue(listGrid, event.rowIndex, "rnum");
			    	 AUIGrid.addCheckedRowsByValue(listGrid, "rnum" , rnum);
                }
            }else{
                AUIGrid.restoreEditedRows(listGrid, "selectedIndex");
                AUIGrid.addUncheckedRowsByIds(listGrid, event.item.rnum);
            }


        }
    });

    AUIGrid.bind(listGrid, "cellDoubleClick", function(event){
    	//alert(event.rowIndex);
    	searchSMO(event.rowIndex);
    	$("#sub_grid_wrap").show();
        AUIGrid.clearGridData(subGrid);
        AUIGrid.resize(subGrid);
    });

    AUIGrid.bind(listGrid, "ready", function(event) {
    });

});
$(function(){
    $('#search').click(function() {
    	   var fromVal = $("#grsdt").val();
           var toVal = $("#gredt").val();
           var from =  new Date( $("#grsdt").datepicker("getDate"));
           var to =  new Date( $("#gredt").datepicker("getDate"));
           if("" != $("#grsdt").val() &&  "" == $("#gredt").val()){
                   Common.alert("Please Check GR To Date.")
                    $("#gredt").focus();
                   return false;
           }else if("" == $("#grsdt").val() &&   "" != $("#gredt").val()){
                   Common.alert("Please Check GR From Date.")
                    $("#grsdt").focus();
                   return false;
           }else if("" !=  $("#grsdt").val() && "" !=  $("#gredt").val() ){
               if(0>= to - from ){
                   Common.alert("Please Check GR Date.")
                   return false;
               }

           }
    	   fromVal = $("#blsdt").val();
           toVal = $("#bledt").val();
           from =  new Date( $("#blsdt").datepicker("getDate"));
           to =  new Date( $("#bledt").datepicker("getDate"));
           if("" != $("#blsdt").val() &&  "" == $("#bledt").val()){
                   Common.alert("Please Check B/L To Date.")
                    $("#bledt").focus();
                   return false;
           }else if("" == $("#blsdt").val() &&   "" != $("#bledt").val()){
                   Common.alert("Please Check B/L From Date.")
                    $("#blsdt").focus();
                   return false;
           }else if("" !=  $("#blsdt").val() && "" !=  $("#bledt").val() ){
               if(0>= to - from ){
                   Common.alert("Please Check B/L Date.")
                   return false;
               }

           }
        SearchListAjax();
    });
    $('#clear').click(function() {
       $('#invno').val('');
       $('#blno').val('');
       $('#location').val('');
       $('#grsdt').val('');
       $('#gredt').val('');
       $('#blsdt').val('');
       $('#bledt').val('');
    });

    $("#download").click(function() {
        GridCommon.exportTo("main_grid_wrap", 'xlsx', "InBound SMO Request List");
    });
    $('#insert').click(function(){
    	var  status = true;
    	var checkedItems = AUIGrid.getCheckedRowItemsAll(listGrid)
    	 if(checkedItems.length <= 0) {
            Common.alert('No data selected.');
            return false;
        }else{
        	   for (var i = 0 ; i < checkedItems.length ; i++){
                   if(null==checkedItems[i].reqQty || 0==checkedItems[i].reqQty){
                       Common.alert('Please Check Req Qty.');
                       status = false;
                       return false;
                       break;
                   }
               }
        }
    	if(status){
        setToCdc();
    	}
    });
    $('#save').click(function(){
	        createSMO();
    });
});


function SearchListAjax() {
    var url = "/logistics/inbound/InBoundList.do";
    var param = $('#searchForm').serializeJSON();
    Common.ajax("POST" , url , param , function(data){
        AUIGrid.setGridData(listGrid, data.dataList);
    });
}

function setToCdc(){
    var selectedItem = AUIGrid.getSelectedIndex(listGrid);
    var whLocId =AUIGrid.getCellValue(listGrid ,selectedItem[0] ,'whLocId');
	doGetCombo('/logistics/inbound/InboundLocation', 'port', whLocId,'flocation', 'S' , '');
	doGetCombo('/logistics/inbound/InboundLocation', '', '','tlocation', 'S' , '');
	$("#popup_wrap").show();
}
function createSMO(){
	if(""==$('#tlocation').val() || null == $('#tlocation').val()){
		  Common.alert("Please Check To Lcation");
		return false;
	}
	var data = {};
	var check   = AUIGrid.getCheckedRowItems(listGrid);
	data.checked = check;
	data.form    = $("#giForm").serializeJSON();
    var url = "/logistics/inbound/reqSMO.do";
    Common.ajax("POST" , url , data , function(data){
    	console.log(data);
    	if("dup"==data.data.reqNo){
    		 Common.alert( " Not enough Qty, Please search again. ");
	        $("#popup_wrap").hide();
    	}else{
	    	Common.alert(data.message+"</br> Created : "+data.data.reqNo+"</br> Created : "+data.data.deliveryNo);
	        $("#popup_wrap").hide();
	        SearchListAjax();
    	}
    	
    });
}

function searchSMO(index){
	 var whLocId =AUIGrid.getCellValue(listGrid ,index ,'whLocId');
	 var blNo =AUIGrid.getCellValue(listGrid ,index ,'blNo');
	 var matrlNo =AUIGrid.getCellValue(listGrid ,index ,'matrlNo');
	 var itmSeq =AUIGrid.getCellValue(listGrid ,index ,'itmSeq');
	var data = {
		      whLocId:whLocId,
			  blNo:blNo,
			  matrlNo:matrlNo,
			  itmSeq:itmSeq,
			  };
    var url = "/logistics/inbound/searchSMO.do";
    Common.ajax("POST" , url , data , function(data){
    	 AUIGrid.setGridData(subGrid, data.dataList);
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
</script>

<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>InBound SMO</li>

</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>InBound SMO</h2>
</aside><!-- title_line end -->

<aside class="title_line"><!-- title_line start -->
<h3></h3>
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
                    <th scope="row">Invoice No</th>
                    <td>
                        <input type="text" class="w100p" id="invno" name="invno">
                    </td>
                    <th scope="row">B/L No</th>
                    <td>
                        <input type="text" class="w100p" id="blno" name="blno">
                    </td>
                    <th scope="row">Location</th>
                    <td>
                        <select class="w100p" id="location" name="location"><option value=''>Choose One</option></select>
                    </td>
                </tr>
                <tr>
                    <th scope="row">B/L Date</th>
                    <td >
                        <div class="date_set w100p"><!-- date_set start -->
                        <p><input id="blsdt" name="blsdt" type="text" title="B/L Start Date"   placeholder="DD/MM/YYYY" class="j_date"></p>
                        <span> To </span>
                        <p><input id="bledt" name="bledt" type="text" title="B/L End Date"  placeholder="DD/MM/YYYY" class="j_date"></p>
                        </div><!-- date_set end -->
                    <th scope="row">GR Date</th>
                    <td>
                        <div class="date_set w100p"><!-- date_set start -->
                        <p><input id="grsdt" name="grsdt" type="text" title="GR Start Date" placeholder="DD/MM/YYYY" class="j_date"></p>
                        <span> To </span>
                        <p><input id="gredt" name="gredt" type="text" title="GR End Date" placeholder="DD/MM/YYYY" class="j_date"></p>
                        </div><!-- date_set end -->
                    </td>
                    <td colspan="2">
                    </td>
                </tr>
                <tr>
                    <th scope="row">PO No.</th>
                    <td>
                        <input type="text" id="pono" name="pono" placeholder="Purchase Order No." class="w100p" />
                    </td>
                    <th scope="row">Vendor No.</th>
                    <td>
                        <input type="text" id="vendorno" name="vendorno" placeholder="Vendor No." class="w100p" />
                    </td>
                </tr>
                <tr>
                    <th scope="row">Material Code</th>
                    <td>
                        <input type="text" id="materialcode" name="materialcode" placeholder="Material Code" class="w100p" />
                    </td>
                    <th scope="row">Material Type</th>
                    <td>
                        <select id="smattype" name="smattype[]" class="multy_select w100p" multiple="multiple"></select>
                    </td>
                    <th scope="row">Material Category</th>
                    <td>
                        <select id="smatcate" name="smatcate[]" class="multy_select w100p" multiple="multiple"></select>
                    </td>
                </tr>
            </tbody>
        </table><!-- table end -->
    </form>

    </section><!-- search_table end -->
    <section class="search_result"><!-- search_result start -->
        <ul class="right_btns">
<c:if test="${PAGE_AUTH.funcPrint == 'Y'}">
            <li><p class="btn_grid"><a id="download"><spring:message code='sys.btn.excel.dw' /></a></p></li>
</c:if>
            <li><p class="btn_grid"><a id="insert">Create SMO</a></p></li>
        </ul>

    <!-- data body start -->
    <section class="search_result"><!-- search_result start -->

        <div id="main_grid_wrap" class="mt10" style="height:450px"></div>


    </section><!-- search_result end -->
    <section class="search_result" ><!-- search_result start -->
        <div id="sub_grid_wrap" class="mt10" style="height:300px; display: none;" ></div>
    </section><!-- search_result end -->


</section>
</section>


<div id="popup_wrap" class="popup_wrap" style="display:none"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1 id="popup_title">Create SMO</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->
<section class="pop_body"><!-- pop_body start -->
<form id="giForm" name="giForm" method="POST">
            <input type="hidden" name="gtype" id="gtype" value="GI"/>
            <input type="hidden" name="serialqty" id="serialqty"/>
            <input type="hidden" name="reqstno" id="reqstno"/>
            <input type="hidden" name="prgnm"  id="prgnm" value="${param.CURRENT_MENU_CODE}"/>
            <table class="type1">
            <caption>search table</caption>
            <colgroup>
                <col style="width:150px" />
                <col style="width:*" />
                <col style="width:150px" />
                <col style="width:*" />
            </colgroup>
            <tbody>
               <tr>
                    <th scope="row">From Location</th>
                    <td>
                         <select class="w100p" id="flocation" name="flocation"></select>
                    </td>
                    <th scope="row">To Location</th>
                    <td >
                        <select class="w100p" id="tlocation" name="tlocation"></select>
                    </td>
                </tr>
            </tbody>
            </table>
            </form>
            <ul class="center_btns">
<c:if test="${PAGE_AUTH.funcChange == 'Y'}">
                <li><p class="btn_blue2 big"><a id="save">SAVE</a></p></li>
</c:if>
                <!-- <li><p class="btn_blue2 big"><a id="cancel">CANCEL</a></p></li> -->
            </ul>
</section><!-- pop_body end -->
<form id='popupForm'>
    <input type="hidden" id="sUrl" name="sUrl">
    <input type="hidden" id="svalue" name="svalue">
</form>
</div><!-- popup_wrap end -->