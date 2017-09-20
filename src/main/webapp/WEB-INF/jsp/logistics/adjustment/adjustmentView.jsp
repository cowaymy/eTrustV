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
<link rel="stylesheet" href="http://code.jquery.com/ui/1.11.1/themes/smoothness/jquery-ui.css">
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery.blockUI.min.js"></script>
<script type="text/javaScript" language="javascript">
var myGridID;
var myGridIDHide;
var myGridIDExcel;


var serialGrid;


var adjNo="${rAdjcode }";
//var adjLocation = "${rAdjlocId }";

var columnLayout=[
                  {dataField:"invntryLocId" ,headerText:"invntryLocId",width:120 ,height:30},
                  {dataField:"invntryNo" ,headerText:"invntryNo",width:120 ,height:30},
                  {dataField:"docDt" ,headerText:"docDt",width:120 ,height:30},
                  {dataField:"locId" ,headerText:"locId",width:120 ,height:30},
                  {dataField:"serialPdChk" ,headerText:"serialPdChk",width:120 ,height:30},
                  {dataField:"serialFtChk" ,headerText:"serialFtChk",width:120 ,height:30},
                  {dataField:"serialPtChk" ,headerText:"serialPtChk",width:120 ,height:30},
                  {dataField:"saveYn" ,headerText:"saveYn",width:120 ,height:30}
                  /* ,{dataField:"seq" ,headerText:"seq",width:120 ,height:30},
                  {dataField:"itmId" ,headerText:"itmId",width:120 ,height:30},
                  {dataField:"itmNm" ,headerText:"itmNm",width:120 ,height:30},
                  {dataField:"itmType" ,headerText:"itmType",width:120 ,height:30},
                  {dataField:"serialChk" ,headerText:"serialChk",width:120 ,height:30},
                  {dataField:"sysQty" ,headerText:"sysQty",width:120 ,height:30},
                  {dataField:"cntQty" ,headerText:"cntQty",width:120 ,height:30},
                  {dataField:"whLocId" ,headerText:"Location ID",width:"20%" ,height:30 },
                  {dataField:"whLocCode" ,headerText:"Location Code",width:"30%" ,height:30},
                  {dataField:"whLocDesc" ,headerText:"Location Desc",width:"50%" ,height:30},
                  {dataField:"whLocTel1" ,headerText:"whLocTel1",width:120 ,height:30 , visible:false},
                  {dataField:"whLocTel2" ,headerText:"whLocTel2",width:120 ,height:30 , visible:false},
                  {dataField:"whLocBrnchId" ,headerText:"whLocBrnchId",width:120 ,height:30 , visible:false},
                  {dataField:"whLocTypeId" ,headerText:"whLocTypeId",width:120 ,height:30 , visible:false},
                  {dataField:"whLocStkGrad" ,headerText:"whLocStkGrad",width:120 ,height:30 , visible:false},
                  {dataField:"whLocStusId" ,headerText:"whLocStusId",width:120 ,height:30 , visible:false},
                  {dataField:"whLocUpdUserId" ,headerText:"whLocUpdUserId",width:120 ,height:30 , visible:false},
                  {dataField:"whLocUpdDt" ,headerText:"whLocUpdDt",width:120 ,height:30 , visible:false},
                  {dataField:"code2" ,headerText:"code2",width:120 ,height:30 , visible:false},
                  {dataField:"desc2" ,headerText:"desc2",width:120 ,height:30 , visible:false},
                  {dataField:"whLocIsSync" ,headerText:"whLocIsSync",width:120 ,height:30 , visible:false},
                  {dataField:"whLocMobile" ,headerText:"whLocMobile",width:120 ,height:30 , visible:false},
                  {dataField:"areaId" ,headerText:"areaId",width:120 ,height:30 , visible:false},
                  {dataField:"addrDtl" ,headerText:"addrDtl",width:120 ,height:30 , visible:false},
                  {dataField:"street" ,headerText:"street",width:120 ,height:30 , visible:false},
                  {dataField:"whLocBrnchId2" ,headerText:"whLocBrnchId2",width:120 ,height:30 , visible:false},
                  {dataField:"whLocBrnchId3" ,headerText:"whLocBrnchId3",width:120 ,height:30 , visible:false},
                  {dataField:"whLocGb" ,headerText:"whLocGb",width:120 ,height:30 , visible:false},
                  {dataField:"serialPdChk" ,headerText:"serialPdChk",width:120 ,height:30 , visible:false},
                  {dataField:"serialFtChk" ,headerText:"serialFtChk",width:120 ,height:30 , visible:false},
                  {dataField:"serialPtChk" ,headerText:"serialPtChk",width:120 ,height:30 , visible:false},
                  {dataField:"commonCrChk" ,headerText:"commonCrChk",width:120 ,height:30 , visible:false} */
               ];          
var resop = {//rowIdField : "rnum"
		//, showRowCheckColumn : true 
		usePaging : false
		//,useGroupingPanel : false 
		,editable:false,
		//exportURL : "/common/exportGrid.do"
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
    	fn_confirm();
    });
     });
 });


function searchHead(){
    //var adjNo="${rAdjcode }";
    //var adjLocation = "${rAdjlocId }";
    var param ="adjNo="+adjNo;
    var url = "/logistics/adjustment/oneAdjustmentNo.do";
    Common.ajax("GET" , url , param , function(result){
        var data = result.dataList;
        console.log(data);
        fn_setVal(data);
        searchGrid();
    });
}

 function searchGrid(){
	//var adjNo="${rAdjcode }";
    //var adjLocation = "${rAdjlocId }";
    var param =
         {
    		invntryNo    : adjNo
    		//invntryLocId     : adjLocation
        };
    var url = "/logistics/adjustment/adjustmentApprovalList.do";
    Common.ajax("GET" , url , param , function(result){
        var data = result.dataList;
        var data2 = result.cnt
        console.log(result);
        AUIGrid.setGridData(myGridID, data);
        fn_chck_approval(data2);        	
    });
}

 function  fn_chck_approval(data2){
	 
	 var total = data2[0].total
	 var y =data2[0].y
	 $('#checkYn').text(y+"/"+total);
	 
	 if(total==y){
		 $('#confirm').show();
	 }else{
		 $('#confirm').hide();
		 
	 }
 }

 function fn_setVal(data){
	    //var status = "${rStatus }";
	    $("#adjno").val(data[0].invntryNo);
	    $("#bsadjdate").text(data[0].baseDt);
	    $("#doctext").text(data[0].headTitle);
	    var tmp = data[0].eventType.split(',');
	    var tmp2 = data[0].itmType.split(',');
	    var tmp3 = data[0].ctgryType.split(',');
	    fn_eventSet(tmp);
	    if(data[0].autoFlag == "A"){
	        $("#auto").attr("checked", true);
	    }else if(data[0].autoFlag == "M"){
	            $("#manual").attr("checked", true);
	    }
	    fn_itemSet(tmp2);
	    fn_itemSet(tmp2,"item");
	    fn_itemSet(tmp3,"catagory");
	    
	    
	    
	}
	function fn_eventSet(tmp){
	    for(var i=0; i<tmp.length;i++){
	        if(tmp[i]=="1"){
	            $("#cdc").attr("checked", true);
	        }else if (tmp[i]=="2") {
	            $("#rdc").attr("checked", true);
	        } else if(tmp[i]=="30"){
	            $("#ctcd").attr("checked", true);  
	        }
	    } 
	    
	}

	function fn_itemSet(tmp,str){
	    var no;
	    if(str=="item"){
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
	    if(str=="item"){
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
  <li><p class="btn_blue"><a id="confirm"><span class="confirm"></span>Confirm</a></p></li>
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
    <th scope="row">Event Type</th>
    <td>
     <label><input type="checkbox" disabled="disabled" id="cdc" name="cdc"/><span>CDC</span></label>
     <label><input type="checkbox" disabled="disabled" id="rdc" name="rdc"/><span>RDC</span></label>
     <label><input type="checkbox" disabled="disabled" id="ctcd" name="ctcd"/><span>CT/CODY</span></label>
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