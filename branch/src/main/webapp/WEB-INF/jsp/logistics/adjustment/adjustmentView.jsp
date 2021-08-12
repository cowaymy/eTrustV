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

.my-row-style {
    background:#9FC93C;
    font-weight:bold;
    color:#22741C;
}
</style>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery.blockUI.min.js"></script>
<script type="text/javaScript" language="javascript">
var myGridID;
var myGridIDHide;
var myGridIDExcel;


var serialGrid;


var adjNo="${rAdjcode }";
//var adjLocation = "${rAdjlocId }";

var columnLayout=[
			{dataField: "invntryLocId",headerText :"<spring:message code='log.head.invntrylocid'/>" ,width:120 ,height:30, visible:false},                          
			{dataField: "invntryNo",headerText :"<spring:message code='log.head.stockauditno'/>"    ,width: "20%"    ,height:30},               
			{dataField: "docDt",headerText :"<spring:message code='log.head.docdate'/>" ,width: "20%"    ,height:30},               
			{dataField: "locId",headerText :"<spring:message code='log.head.locationid'/>"  ,width: "20%"    ,height:30},               
			{dataField: "locName",headerText :"<spring:message code='log.head.locationname'/>"  ,width: "20%"    ,height:30},               
			/*                   {dataField:    "serialPdChk",headerText :"<spring:message code='log.head.serialpdchk'/>"   ,width:120 ,height:30},                         
			{dataField: "serialFtChk",headerText :"<spring:message code='log.head.serialftchk'/>"   ,width:120 ,height:30},                         
			{dataField: "serialPtChk",headerText :"<spring:message code='log.head.serialptchk'/>"   ,width:120 ,height:30}, */                          
			{dataField: "saveYn",headerText :"<spring:message code='log.head.countstatus'/>"    ,width: "20%"    ,height:30} 
               ];          
var resop = {
		usePaging : false
		,editable:false
		};
$(document).ready(function(){
	searchHead();
     
    myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout,"", resop);
//btn clickevent
$(function(){
    
    $('#list').click(function() {
        document.listForm.action = '/logistics/adjustment/NewAdjustmentRe.do';
        document.listForm.submit();
    });
    $('#confirm').click(function() {
    	//fn_confirm();
    });
     });
 });


function searchHead(){
    var param ="adjNo="+adjNo;
    var url = "/logistics/adjustment/oneAdjustmentNo.do";
    Common.ajax("GET" , url , param , function(result){
        var data = result.dataList;
        
        fn_setVal(data);
        searchGrid();
    });
}

 function searchGrid(){
    var param =
         {
    		invntryNo    : adjNo
        };
    var url = "/logistics/adjustment/adjustmentApprovalList.do";
    Common.ajax("GET" , url , param , function(result){
        var data = result.dataList;
        var data2 = result.cnt
        
        AUIGrid.setGridData(myGridID, data);
        fn_chck_approval(data2);        	
    });
}

 function  fn_chck_approval(data2){
	 
	 var total = data2[0].total
	 var y =data2[0].y
	 $('#checkYn').text(y+"/"+total);
	 
 }

 function fn_setVal(data){
	    $("#adjno").val(data[0].invntryNo);
	    $("#bsadjdate").text(data[0].baseDt);
	    $("#doctext").text(data[0].headTitle);
	    var tmp = data[0].eventType.split(',');
	    var tmp2 = data[0].itmType.split(',');
	    var tmp3 = data[0].ctgryType.split(',');
	    if(data[0].autoFlag == "A"){
	        $("#auto").attr("checked", true);
	    }else if(data[0].autoFlag == "M"){
	            $("#manual").attr("checked", true);
	    }
	    fn_itemSet(tmp,"event");
	    fn_itemSet(tmp2,"item");
	    fn_itemSet(tmp3,"catagory");
	    
	    
	}

	function fn_itemSet(tmp,str){
	    var no;
        if(str=="event"){
            no=339;
        }else if(str=="item"){
            no=15;
        }else if(str=="catagory"){
            no=11;
        }   
	    var url = "/logistics/adjustment/selectCodeList.do";
	    $.ajax({
	        type : "GET",
	        url : url,
	        data : {
	            groupCode : no
	        },
	        dataType : "json",
	        contentType : "application/json;charset=UTF-8",
	        success : function(data) {
	             fn_itemChck(data,tmp,str);
	        },
	        error : function(jqXHR, textStatus, errorThrown) {
	        },
	        complete : function() {
	        }
	    });
	}
	function  fn_itemChck(data,tmp2,str){
	    var obj;
	    if(str=="event" ){
	        obj ="eventtypetd";
	    }else if(str=="item"){
	        obj ="itemtypetd";
	    }else if(str=="catagory"){
	        obj ="catagorytypetd";
	    }
	    obj= '#'+obj;
	    
	    $.each(data, function(index,value) {
	                $('<label />',{id:data[index].code}).appendTo(obj);
	                $('<input />',  {type : 'checkbox',value : data[index].codeId, id : data[index].codeId}).appendTo("#"+data[index].code).attr("disabled","disabled");
	                $('<span />',  {text:data[index].codeName}).appendTo("#"+data[index].code);
	        });
	            
	        for(var i=0; i<tmp2.length;i++){
	            $.each(data, function(index,value) {
	                if(tmp2[i]==data[index].codeId){
	                    $("#"+data[index].codeId).attr("checked", "true");
	                }
	            });
	        }
	}

</script>

<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>logistics</li>
    <li>View-Stock Audit</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>View-Stock Audit</h2>
</aside><!-- title_line end -->

<aside class="title_line"><!-- title_line start -->
<h3>Header Info</h3>
<ul class="right_btns">
    <li><p class="btn_blue"><a id="list"><span class="list"></span>List</a></p></li>
 <!--  <li><p class="btn_blue"><a id="confirm"><span class="confirm"></span>Confirm</a></p></li> -->
</ul>
</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->
<form id="headForm" name="headForm" method="POST">
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:180px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Stock Audit Number</th>
    <td><input id="adjno" name="adjno" type="text" title=""  class="w100p" readonly="readonly" /></td>
    <th scope="row">Auto/Manual</th>
    <td> 
         <label><input type="radio" name="auto" id="auto"    disabled="disabled" /><span>Auto</span></label>
         <label><input type="radio" name="manual" id="manual"   disabled="disabled" /><span>Manual</span></label>        
    </td>
</tr>
<tr>
    <th scope="row">Location Type</th>
   <td id="eventtypetd">
   </td>
    <th scope="row">Items Type</th>
    <td id="itemtypetd">
    </td>
    </tr>
    <tr>
    <th scope="row">Category Type</th>
        <td id="catagorytypetd">
    <th scope="row">Stock Audit Date</th>
    <td id="bsadjdate">
    </td>  
    </tr>
    <tr>
        <th scope="row">Remark</th>
        <td colspan='3' id="doctext"><!-- <input type="text" name="doctext" id="doctext" class="w100p"  readonly="readonly"/> --></td>
    </tr>
    <tr>
    <th scope="row">Check Approval</th>
    <td id="checkYn">
    </td>
    <td colspan="2"/>
    </tr>
</tbody>
</table><!-- table end -->

</form>
</section><!-- search_table end -->

	<section class="search_result"><!-- search_result start -->

<article class="grid_wrap"><!-- grid_wrap start -->
        <div id="grid_wrap"></div>
</article>
<form id="listForm" name="listForm" method="POST">
<input type="hidden" id="retnVal"    name="retnVal"    value="R"/>
</form>