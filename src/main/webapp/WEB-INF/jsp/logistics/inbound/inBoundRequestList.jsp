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
<link rel="stylesheet" href="http://code.jquery.com/ui/1.11.1/themes/smoothness/jquery-ui.css">
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery.blockUI.min.js"></script>
<script type="text/javaScript" language="javascript">
var listGrid;
var subGrid;

var rescolumnLayout=[
							 {dataField:"rnum" ,headerText:"rnum",width:120 ,height:30,editable:false, visible:false},
							 {dataField:"whLocId" ,headerText:"whLocId",width:120 ,height:30,editable:false, visible:false},
							 {dataField:"whLocCode" ,headerText:"whLocCode",width:120 ,height:30,editable:false, visible:false},
							 {dataField:"whLocDesc" ,headerText:"Port",width:250 ,height:30,editable:false
                              ,cellMerge : true  },
							 {dataField:"plant" ,headerText:"plant",width:120 ,height:30,editable:false, visible:false},
							 {dataField:"blNo" ,headerText:"BL No.",width:200 ,height:30,editable:false,
                              cellMerge : true,
                              mergeRef : "whLocDesc", // 이전 칼럼(대분류) 셀머지의 값을 비교해서 실행함. (mergePolicy : "restrict" 설정 필수)
                              mergePolicy : "restrict"     },
							 {dataField:"itmSeq" ,headerText:"Seq.",width:120 ,height:30,editable:false},
							 {dataField:"stkid" ,headerText:"stkid",width:120 ,height:30,editable:false, visible:false},
							 {dataField:"matrlNo" ,headerText:"Material Cd.",width:120 ,height:30,editable:false},
							 {dataField:"stkTypeId" ,headerText:"stkTypeId",width:120 ,height:30,editable:false, visible:false},
							 {dataField:"typename" ,headerText:"Type",width:120 ,height:30,editable:false},
							 {dataField:"stkCtgryId" ,headerText:"stkCtgryId",width:120 ,height:30,editable:false, visible:false},
							 {dataField:"ctgryname" ,headerText:"Catagory",width:120 ,height:30,editable:false},
							 {dataField:"stkdesc" ,headerText:"Material",width:250,height:30,editable:false},
							 {dataField:"uom" ,headerText:"uom",width:120 ,height:30,editable:false, visible:false},
							 {dataField:"uomnm" ,headerText:"UOM",width:120 ,height:30,editable:false},
							 {dataField:"qty" ,headerText:"System Qty",width:120 ,height:30,editable:false},
							 {dataField:"reqedQty" ,headerText:"Requested Qty",width:120 ,height:30,editable:false},
							 {dataField:"avrqty" ,headerText:"Available Qty",width:120 ,height:30,editable:false},
							 {dataField:"reqQty" ,headerText:"Req. Qty",width:120 ,height:30}
							];

var smoLayout=[
						{dataField:"reqstNo" ,headerText:"Reqst No",width:200 ,height:30},
						{dataField:"trnscType" ,headerText:"Trnsc Type",width:120 ,height:30},
						{dataField:"trnscTypeDtl" ,headerText:"Trnsc Type Dtl",width:120 ,height:30},
						{dataField:"pridicFrqncy" ,headerText:"pridicFrqncy",width:120 ,height:30, visible:false},
						{dataField:"reqstCrtDt" ,headerText:"Reqst Crt Dt",width:120 ,height:30},
						{dataField:"reqstRequireDt" ,headerText:"reqstRequireDt",width:120 ,height:30, visible:false},
						{dataField:"refDocNo" ,headerText:"refDocNo",width:120 ,height:30, visible:false},
						{dataField:"docHderTxt" ,headerText:"docHderTxt",width:120 ,height:30, visible:false},
						{dataField:"goodsRcipt" ,headerText:"goodsRcipt",width:120 ,height:30, visible:false},
						{dataField:"rcivCdcRdc" ,headerText:"rcivCdcRdc",width:120 ,height:30, visible:false},
						{dataField:"rcivCdcRdc2" ,headerText:"From",width:200 ,height:30},
						{dataField:"reqstCdcRdc" ,headerText:"reqstCdcRdc",width:120 ,height:30, visible:false},
						{dataField:"reqstCdcRdc2" ,headerText:"To",width:200 ,height:30},
						{dataField:"reqstRem" ,headerText:"reqstRem",width:120 ,height:30, visible:false},
						{dataField:"retnDefectResn" ,headerText:"retnDefectResn",width:120 ,height:30, visible:false},
						{dataField:"retnPrsnCtCody" ,headerText:"retnPrsnCtCody",width:120 ,height:30, visible:false},
						{dataField:"crtUserId " ,headerText:"crtUserId ",width:120 ,height:30, visible:false},
						{dataField:"crtDt" ,headerText:"crtDt",width:120 ,height:30, visible:false},
						{dataField:"reqstStus" ,headerText:"reqstStus",width:120 ,height:30, visible:false},
						{dataField:"reqstDel" ,headerText:"reqstDel",width:120 ,height:30, visible:false},
						{dataField:"reqstType" ,headerText:"reqstType",width:120 ,height:30, visible:false},
						{dataField:"reqstTypeDtl" ,headerText:"reqstTypeDtl",width:120 ,height:30, visible:false},
						{dataField:"reqstNoItm" ,headerText:"Reqst No Itm",width:120 ,height:30},
						{dataField:"itmCode" ,headerText:"Itm Code",width:120 ,height:30},
						{dataField:"itmName" ,headerText:"Itm Name",width:120 ,height:30},
						{dataField:"reqstQty" ,headerText:"Reqst Qty",width:120 ,height:30},
						{dataField:"uom" ,headerText:"uom",width:120 ,height:30, visible:false},
						{dataField:"uomname" ,headerText:"UOM",width:120 ,height:30},
						{dataField:"itmTxt" ,headerText:"itmTxt",width:120 ,height:30, visible:false},
						{dataField:"finalCmplt" ,headerText:"finalCmplt",width:120 ,height:30, visible:false},
						{dataField:"crtUserId" ,headerText:"User Id",width:120 ,height:30},
						{dataField:"crtDt" ,headerText:"crtDt",width:120 ,height:30, visible:false},
						{dataField:"updUserId" ,headerText:"updUserId",width:120 ,height:30, visible:false},
						{dataField:"updDt" ,headerText:"updDt",width:120 ,height:30, visible:false},
						{dataField:"rciptQty" ,headerText:"rciptQty",width:120 ,height:30, visible:false},
						{dataField:"blNo" ,headerText:"BL No",width:120 ,height:30}
                     ];
var reqop = {
		            enableCellMerge : true,
					showRowCheckColumn : true ,
					editable : true,
					usePaging : false ,
					showStateColumn : false
		         };
var smoop = {
		            enableCellMerge : true,
					editable : false,
					usePaging : false ,
					showStateColumn : false
		         };

$(document).ready(function(){
    
   doGetCombo('/logistics/inbound/InboundLocation', 'port', '','location', 'S' , ''); 
   listGrid = AUIGrid.create("#main_grid_wrap", rescolumnLayout, reqop);
   subGrid  = AUIGrid.create("#sub_grid_wrap", smoLayout, smoop);
    
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
                	Common.alert('Req Qty can not be greater than Available Qty.');
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
    $('#insert').click(function(){
    	var  status = true;
    	var checkedItems = AUIGrid.getCheckedRowItemsAll(listGrid)
    	 if(checkedItems.length <= 0) {
            Common.alert('No data selected.');
            return false;
        }else{
        	   for (var i = 0 ; i < checkedItems.length ; i++){
        		   console.log(checkedItems[i].reqQty);
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
    console.log(param);
    Common.ajax("POST" , url , param , function(data){
    	console.log(data);
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
	var data = {};
	var check   = AUIGrid.getCheckedRowItems(listGrid);
	data.checked = check;
	data.form    = $("#giForm").serializeJSON();
    var url = "/logistics/inbound/reqSMO.do";
    Common.ajax("POST" , url , data , function(data){
        $("#popup_wrap").hide();
        SearchListAjax();
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
    console.log(data);
    Common.ajax("POST" , url , data , function(data){
    console.log(data);
    	 AUIGrid.setGridData(subGrid, data.dataList);
    });
}
</script>

<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>InBound</li>
    <li>View - Request</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>InBound's SMO Request List</h2>
</aside><!-- title_line end -->

<aside class="title_line"><!-- title_line start -->
<h3></h3>
    <ul class="right_btns">
    <li><p class="btn_blue"><a id="search"><span class="search"></span>Search</a></p></li>
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
                    <th scope="row">GR Date</th>
                    <td>
                        <div class="date_set"><!-- date_set start -->
                        <p><input id="grsdt" name="grsdt" type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date"></p>   
                        <span> ~ </span>
                        <p><input id="gredt" name="gredt" type="text" title="Create End Date" placeholder="DD/MM/YYYY" class="j_date"></p>
                        </div><!-- date_set end -->                        
                    </td>
                    <th scope="row">B/L Date</th>
                    <td >
                        <div class="date_set"><!-- date_set start -->
                        <p><input id="blsdt" name="blsdt" type="text" title="Create start Date"   placeholder="DD/MM/YYYY" class="j_date"></p>   
                        <span> ~ </span>
                        <p><input id="bledt" name="bledt" type="text" title="Create End Date"  placeholder="DD/MM/YYYY" class="j_date"></p>
                        </div><!-- date_set end -->
                   <!--  <th scope="row">Status</th>
                    <td>
                        <select class="w100p" id="status" name="status">
                           <option value="N"  selected="selected">Not Yet</option>
                           <option value="D">Done</option>
                        </select>
                    </td> -->
                    <td colspan="2">
                    </td>
                </tr>
            </tbody>
        </table><!-- table end -->
    </form>

    </section><!-- search_table end -->
    <section class="search_result"><!-- search_result start -->
        <ul class="right_btns">
            <li><p class="btn_grid"><a id="insert"><span class="search"></span>Create SMO</a></p></li>            
        </ul>

    <!-- data body start -->
    <section class="search_result"><!-- search_result start -->

        <div id="main_grid_wrap" class="mt10" style="height:300px"></div>
        

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
                <li><p class="btn_blue2 big"><a id="save">SAVE</a></p></li>
                <!-- <li><p class="btn_blue2 big"><a id="cancel">CANCEL</a></p></li> -->
            </ul>
</section><!-- pop_body end -->
<form id='popupForm'>
    <input type="hidden" id="sUrl" name="sUrl">
    <input type="hidden" id="svalue" name="svalue">
</form>
</div><!-- popup_wrap end -->