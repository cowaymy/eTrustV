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
                  {dataField:"saveYn" ,headerText:"saveYn",width:120 ,height:30},
                  {dataField:"seq" ,headerText:"seq",width:120 ,height:30},
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
                  {dataField:"commonCrChk" ,headerText:"commonCrChk",width:120 ,height:30 , visible:false}
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
    $('#approve').click(function() {
    	var status="A";
        fn_updateApproval(status);
    });
    $('#reject').click(function() {
    	var status="R";
    	fn_updateApproval(status);
    });
    $('#approve2').click(function() {
    	var status="A2";
        fn_updateApproval(status);
    });
    $('#reject2').click(function() {
    	var status="R2";
    	fn_updateApproval(status);
    });
    $('#complete').click(function() {
        var formData = new FormData();
        formData.append("excelFile", $("input[name=pdfUpload]")[0].files[0]);
        //formData.append("param01", "param01");
       // formData.append("param02", "param02");
        formData.append("adjNo", adjNo);

        Common.ajaxFile("/logistics/adjustment/pdfUpload.do", formData, function (result) {
            //Common.alert("완료~")
            console.log(result);
        });
    });
/*     $('#confirm').click(function() {
    	fn_confirm();
    }); */
     });
 });

 function searchHead(){
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
		// $('#confirm').show();
	 }else{
		// $('#confirm').hide();
		 
	 }
	 
	 
	 var param =
     {
        invntryNo    : adjNo
        //invntryLocId     : adjLocation
    };
var url = "/logistics/adjustment/adjustmentApprovalLineCheck.do";
Common.ajax("GET" , url , param , function(result){
   var data = result.dataList;
   // var data2 = result.cnt
    console.log(data);
    //AUIGrid.setGridData(myGridID, data);
    //fn_chck_approval(data2);            
    fn_approvalStatus(data);
});
 }

function fn_approvalStatus(data){
	if(null==data[0].cnfm1 ||""==data[0].cnfm1){
		$("#approve").show();
		$("#reject").show();
		$("#approve2").hide();
		$("#reject2").hide();
	}else if("A"==data[0].cnfm1){
        $("#approve2").show();
        $("#reject2").show();
	}else if("A"==data[0].cnfm2){
		$("#approve").hide();
		$("#reject").hide();
		$("#approve2").hide();
		$("#reject2").hide();
	}else if("R"==data[0].cnfm2){
		$("#approve").show();
		$("#reject").show();
		$("#approve2").hide();
		$("#reject2").hide();
	}
	
	if("A"==data[0].cnfm1 & "A"==data[0].cnfm2){
		$("#auto_file").show();
	      $("#approve").hide();
	        $("#reject").hide();
	        $("#approve2").hide();
	        $("#reject2").hide();
	}else{
		$("#auto_file").hide();
	}
		$("#lcdYn").text(data[0].cnfm1);
		$("#finYn").text(data[0].cnfm2);
	
}

function fn_updateApproval(status){
	
	var chckAuthority="";// 권한 업데이트 함수 또는 팀으로 세팅 할 예정
	if(status == "A"){
	}
	else if(status == "R"){
	}	

	var param =
    {
       invntryNo    : adjNo,
       //invntryLocId     : adjLocation
       status     : status
   };
   console.log(param);
var url = "/logistics/adjustment/ApprovalUpdate.do";
Common.ajax("GET" , url , param , function(result){
  var data = result.dataList;
  // var data2 = result.cnt
   console.log(data);
   //AUIGrid.setGridData(myGridID, data);
   //fn_chck_approval(data2);            
   fn_approvalStatus(data);
});

} 
</script>

<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>logistics</li>
    <li>Approval -Stock Audit</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>Approval -Stock Audit</h2>
</aside><!-- title_line end -->

<aside class="title_line"><!-- title_line start -->
<h3>Header Info</h3>
<ul class="right_btns">
    <li><p class="btn_blue"><a id="list"><span class="list"></span>List</a></p></li>
  <!-- <li><p class="btn_blue"><a id="confirm"><span class="confirm"></span>Confirm</a></p></li> -->
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
    <!-- <select class="multy_select" multiple="multiple" id="eventtype" name="eventtype[]" /></select> -->
     <label><input type="checkbox" disabled="disabled" id="cdc" name="cdc"/><span>CDC</span></label>
     <label><input type="checkbox" disabled="disabled" id="rdc" name="rdc"/><span>RDC</span></label>
     <label><input type="checkbox" disabled="disabled" id="ctcd" name="ctcd"/><span>CT/CODY</span></label>
    </td>
  <!--   <th scope="row">Document Date</th>
    <td><input id="docdate" name="docdate" type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" /></td>
</tr>
<tr> -->
    <th scope="row">Items Type</th>
    <td id="itemtypetd">
    </tr>
    <tr>
    <th scope="row">Stock Audit Date</th>
    <td id="bsadjdate">
    </td>  
    <td colspan="2"/> 
    </tr>
    <tr>
        <th scope="row">Remark</th>
        <td colspan='3' id="doctext"><!-- <input type="text" name="doctext" id="doctext" class="w100p"  readonly="readonly"/> --></td>
    </tr>
    <tr>
    <th scope="row">Check Approval</th>
    <td id="checkYn">
    <td colspan="2"/>
    </tr>
</tbody>
</table><!-- table end -->

</form>
</section><!-- search_table end -->

<aside class="title_line"><!-- title_line start -->
<h3>Location Info</h3>
</aside><!-- title_line end -->
<ul class="left_btns">
    <li><p class="btn_blue"><a id="approve"><span class="approve"></span>Approve</a></p></li>
  <li><p class="btn_blue"><a id="reject"><span class="reject"> </span>Reject</a></p></li>
    <li><p class="btn_blue"><a id="approve2"><span class="approve2"></span> Approve</a></p></li>
  <li><p class="btn_blue"><a id="reject2"><span class="reject2"></span> Reject2</a></p></li>
  <li><p class="btn_blue"><div class="auto_file" id="auto_file"><!-- auto_file start -->
                                    <input type="file" id="fileSelector" name="pdfUpload" title="file add" accept=".pdf"/>
                                </div>
    </p></li>
  <li><p class="btn_blue"><a id="complete"><span class="complete"></span>Complete</a></p></li>
</ul>
<section class="search_table"><!-- search_table start -->
<form id="searchForm" name="searchForm" >

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:140px" />
    <col style="width:*" />
    <col style="width:100px" />
    <col style="width:*" />
    <col style="width:90px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr> 
    <td id="lcdYn">
    </td>
    <th scope="row">Finance</th>
    <td id="finYn">
    </td>
    <th colspan="2" />
</tr>
</tbody>
</table><!-- table end -->

</form>
</section><!-- search_table end -->

	<section class="search_result"><!-- search_result start -->

<article class="grid_wrap"><!-- grid_wrap start -->
        <div id="grid_wrap"></div>
</article>
</section>