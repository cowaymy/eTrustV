<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>


<script type="text/javaScript">
var gridID1;
function tagRespondGrid() {
		
		var columnLayout1 =[
					                   {
					                       dataField: "mainDepartment",
					                       headerText: "Main Dept",
					                       width: 160
					                   },
					                   {
					                       dataField: "subDepartment",
					                       headerText: "Sub Dept",
					                       width: 160
					                   },
					                   {
					                       dataField: "remarkCont",
					                       headerText: "Remark",
					                       width: 160
					                   },
					                   {
                                           dataField: "regNm",
                                           headerText: "Register",
                                           width: 160
                                       },
					                   {
					                       dataField: "statusNm",
					                       headerText: "Status",					                      
					                       width: 120
					                   },
					                   {
					                       dataField: "crtDate",
					                       headerText: "Date",
					                       dataType : "date"
					                
					                   }
		                   
			                   ];
	                   
	var gridPros1 = {  
	        pageRowCount        : 20,           //한 화면에 출력되는 행 개수 20(기본값:20)            
	        showStateColumn     : false,             
	        displayTreeOpen     : false,            
	        selectionMode       : "singleRow",  //"multipleCells",            
	        skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
	        wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
	        showRowNumColumn    : true,         //줄번호 칼럼 렌더러 출력    
	        editable :false 
	};  
	
	gridID1 = GridCommon.createAUIGrid("respond_grid_wrap", columnLayout1  ,"" ,gridPros1);



}



$(document).ready(function(){
	
	//grid 생성
	tagRespondGrid();
	
	$("#respondInfo").click(function() {
		
		  var counselingNum = $("#counselingNo").text();
		    Common.ajax("Get", "/services/tagMgmt/getRemarkResults.do?counselingNo="+ counselingNum +"", '' , function(result) {
		    	 console.log("성공.");
		         console.log("data : "+ result);
		        AUIGrid.setGridData(gridID1 , result );
		        AUIGrid.resize(gridID1,900,300);
		    });
	});
	
	  doGetCombo('/services/tagMgmt/selectMainDept.do', '' , '', 'inputMainDept' , 'S', '');
	
	
	   $("#inputMainDept").change(function(){
         
         
         if($("#inputMainDept").val() == ''){
             $("#inputSubDept").val('');
             $("#inputSubDept").find("option").remove();
         }else{
        	 doGetCombo('/services/tagMgmt/selectSubDept.do',  $("#inputMainDept").val(), '','inputSubDept', 'S' ,  ''); 
         }
         
     });
	   
	   
	

	
});



function fn_saveRemarkResult(){

	  var jsonObj = { 
			 "remark" : $("#remark").val(),
			 "status" : $("#status").val(),
			  "counselingNo" :  $("#counselingNo").text(),
			  "mainDept" : $("#mainDept").val(),
			  "subDept" : $("#subDept").val(),
			  "regDate" : $("#regDate").text(),
			  "orderId" : $("#ordId").val(),
			  "hcId" : $("#hcId").val(),
			  "inputMainDept" : $("#inputMainDept").val(),
			  "inputSubDept" : $("#inputSubDept").val()
	       };
	 var regDate =  $("#orderId").val();
	  console.log(regDate);
	  
	
	 Common.ajax("POST", "/services/tagMgmt/addRemarkResult.do", jsonObj , function(result) {
		  
		  
		  Common.alert(result.message);
		  
	  }); 
	

}









</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->


<header class="pop_header"><!-- pop_header start -->
<h1>Tag Log Detail INFO </h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->


<section class="pop_body"><!-- pop_body start -->
<input type="hidden" id="hcId"   value= "${tagMgmtDetail.hcId}">
<input  type="hidden" id="ordId"  value= "${tagMgmtDetail.ordId}">
<section class="tap_wrap"><!-- tap_wrap start -->
<ul class="tap_type1">
    <li><a href="#" class="on">Tag Info</a></li>
    <li><a href="#" id="respondInfo">Respond Info</a></li>
</ul>

<!-- Tag Info Start -->
<article class="tap_area"><!-- tap_area start -->
    <section class="tap_wrap mt0"><!-- tap_wrap start -->
    <ul class="tap_type1">
        <li><a href="#" class="on">Tag Basic Info</a></li>
        <li><a href="#" >Caller Info</a></li>
    </ul>
    <!-- Tag Basic Info Start -->
    <article class="tap_area"><!-- tap_area start -->
        <table class="type1"><!-- table start -->
        <caption>table</caption>
        <colgroup>
            <col style="width:180px" />
            <col style="width:*" />
            <col style="width:180px" />
            <col style="width:*" />
            <col style="width:160px" />
            <col style="width:*" />
        </colgroup>
        <tbody>
        <tr>
            <th scope="row">Inquiry Contact Number</th>
            <td><span id="counselingNo"><c:out value="${tagMgmtDetail.counselingNo}"/></span></td>
            <th scope="row">Inquiry Customer Name</th>
            <td><span><c:out value="${tagMgmtDetail.customerName}"/></span></td>
            <th scope="row">Inquiry Member Type</th>
            <td><span><c:out value="${tagMgmtDetail.classifyMem }"/></span></td>
        </tr>
        <tr>
            <th scope="row">Initial Main Dept.</th>
            <td><span ><c:out value="${tagMgmtDetail.mainDept }"/></span></td>
            <th scope="row">Initial Sub Dept.</th>
            <td><span ><c:out value="${tagMgmtDetail.subDept }"/></span></td>
            <th scope="row">Main Inquiry</th>
            <td><span ><c:out value="${tagMgmtDetail.mainInquiry }"/></span></td>
        </tr>
        <tr>
            <th scope="row">Customer Code</th>
            <td><span><c:out value="${tagMgmtDetail.customerNo }"/></span></td>
            <th scope="row">Order Number</th>
            <td><span><c:out value="${tagMgmtDetail.ordNo }"/></span></td>
            <th scope="row">Sub Main Inquiry</th>
            <td><span><c:out value="${tagMgmtDetail.subInquiry }"/></span></td>
        </tr>
        <tr>
            <th scope="row">Progress Status</th>
            <td><span><c:out value="${tagMgmtDetail.status }"/></span></td>
            <th scope="row">Complete Key-in Date</th>
            <td><span id="regDate"><c:out value="${tagMgmtDetail.regDate }"/></span></td>
            <th scope="row">Feedback Code</th>
            <td><span><c:out value="${tagMgmtDetail.feedbackCode }"/></span></td>
        </tr>
        <tr>
            <th scope="row">Latest Main Dept</th>
            <td><span ><c:out value="${tagMgmtDetail.latestMainDept }"/></span>
                <input type="hidden" id ="mainDept" value="${tagMgmtDetail.deptCode}">
            </td>
            
            <th scope="row">Latest Sub Dept</th>
            <td><span><c:out value="${tagMgmtDetail.latestSubDept }"/></span>
                <input type="hidden" id ="subDept" value="${tagMgmtDetail.subDeptCde}">
            </td>
         <th scope="row"></th>
            <td><span></span></td>
        </tr>
        </tbody>
        </table><!-- table end -->
        <section class="tap_wrap"><!-- tap_wrap start -->
            <ul class="tap_type1">
                <li><a href="#" class="on">Order Info</a></li>
                <li><a href="#">HP/Cody Info</a></li>
            </ul>
            <!-- Order Info Start -->
            <article class="tap_area"><!-- tap_area start -->
                <table class="type1"><!-- table start -->
                <caption>table</caption>
                <colgroup>
                    <col style="width:180px" />
                    <col style="width:*" />
                    <col style="width:180px" />
                    <col style="width:*" />
                    <col style="width:180px" />
                    <col style="width:*" />
                </colgroup>
                <tbody>
                <tr>
                    <th scope="row">Order No</th>
                    <td><span><c:out value="${tagMgmtDetail.ordNo }"/></span></td>
                    <th scope="row">App Type</th>
                    <td><span><c:out value="${orderInfo.codeDesc }"/></span></td>
                    <th scope="row">Product</th>    
                    <td><span><c:out value="${orderInfo.stkDesc }"/></span></td>
                </tr>
                <tr>
                    <th scope="row">Customer Name</th>
                    <td><span><c:out value="${orderInfo.name }"/></span></td>
                    <th scope="row">NRC Company No</th>
                    <td colspan="3"><span><c:out value="${orderInfo.nric }"/></span></td>
                </tr>
                </tbody>
                </table><!-- table end -->
            </article><!-- tap_area end -->
            <!-- Order Info End -->

            <!-- HP/Cody Info Start -->
            <article class="tap_area"><!-- tap_area start -->
                <article class="grid_wrap"><!-- grid_wrap start -->
                    <div class="divine_auto"><!-- divine_auto start -->
                        <div style="width:50%;">
                            <aside class="title_line"><!-- title_line start -->
                            <h3 class="pt0">Salesman Info</h3>
                            </aside><!-- title_line end -->

                            <table class="type1"><!-- table start -->
                            <caption>table</caption>
                            <colgroup>
                                <col style="width:180px" />
                                <col style="width:*" />
                            </colgroup>
                            <tbody>
                            <tr>
    <th rowspan="3" scope="row">Order Made By</th>
    <td><span class="txt_box">${salesmanInfo.orgCode} (Organization Code)<i>(${salesmanInfo.memCode1}) ${salesmanInfo.name1} - ${salesmanInfo.telMobile1}</i></span></td>
</tr>
<tr>
    <td><span class="txt_box">${salesmanInfo.grpCode} (Group Code)<i>(${salesmanInfo.memCode2}) ${salesmanInfo.name2} - ${salesmanInfo.telMobile2}</i></span></td>
</tr>
<tr>
    <td><span class="txt_box">${salesmanInfo.deptCode} (Department Code)<i>(${salesmanInfo.memCode3}) ${salesmanInfo.name3} - ${salesmanInfo.telMobile3}</i></span></td>
</tr>
<tr>
    <th scope="row">Salesman Code</th>
    <td><span>${salesmanInfo.memCode}</span></td>
</tr>
<tr>
    <th scope="row">Salesman Name</th>
    <td><span>${salesmanInfo.name}</span></td>
</tr>
<tr>
    <th scope="row">Salesman NRIC</th>
    <td><span>${salesmanInfo.nric}</span></td>
</tr>
<tr>
    <th scope="row">Mobile No</th>
    <td><span>${salesmanInfo.telMobile}</span></td>
</tr>
<tr>
    <th scope="row">Office No</th>
    <td><span>${salesmanInfo.telOffice}</span></td>
</tr>
<tr>
    <th scope="row">House No</th>
    <td><span>${salesmanInfo.telHuse}</span></td>
</tr>
                            </tbody>
                            </table><!-- table end -->
                        </div>
                        <div style="width:50%;">
                            <aside class="title_line"><!-- title_line start -->
                            <h3 class="pt0">Cody Info</h3>
                            </aside><!-- title_line end -->

                            <table class="type1"><!-- table start -->
                            <caption>table</caption>
                            <colgroup>
                                <col style="width:180px" />
                                <col style="width:*" />
                            </colgroup>
                            <tbody>
                            <tr>
    <th rowspan="3" scope="row">Service By</th>
    <td><span class="txt_box">${codyInfo.orgCode} (Organization Code)<i>(${codyInfo.memCode1}) ${codyInfo.name1} - ${codyInfo.telMobile1}</i></span></td>
</tr>
<tr>
    <td><span class="txt_box">${codyInfo.grpCode} (Group Code)<i>(${codyInfo.memCode2}) ${codyInfo.name2} - ${codyInfo.telMobile2}</i></span></td>
</tr>
<tr>
    <td><span class="txt_box">${codyInfo.deptCode} (Department Code)<i>(${codyInfo.memCode3}) ${codyInfo.name3} - ${codyInfo.telMobile3}</i></span></td>
</tr>
<tr>
    <th scope="row">Cody Code</th>
    <td><span>${codyInfo.memCode}</span></td>
</tr>
<tr>
    <th scope="row">Cody Name</th>
    <td><span>${codyInfo.name}</span></td>
</tr>
<tr>
    <th scope="row">Cody NRIC</th>
    <td><span>${codyInfo.nric}</span></td>
</tr>
<tr>
    <th scope="row">Mobile No</th>
    <td><span>${codyInfo.telMobile}</span></td>
</tr>
<tr>
    <th scope="row">Office No</th>
    <td><span>${codyInfo.telOffice}</span></td>
</tr>
<tr>
    <th scope="row">House No</th>
    <td><span>${codyInfo.telHuse}</span></td>
</tr>
                            </tbody>
                            </table><!-- table end -->
                        </div>
                    </div><!-- divine_auto end -->
                </article><!-- grid_wrap end -->
            </article><!-- tap_area end -->
            <!-- HP/Cody Info End -->

        </section><!-- tap_wrap end -->
    </article><!-- tap_area end -->
    <!-- Tag Basic Info End -->

    <!-- Caller Info Start -->
    <article class="tap_area"><!-- tap_area start -->
        <table class="type1"><!-- table start -->
        <caption>table</caption>
        <colgroup>
            <col style="width:180px" />
            <col style="width:*" />
        </colgroup>
        <tbody>
        <tr>
            <th scope="row">Name</th>
            <td><span><c:out value="${callerInfo.name }"/></span></td>
            <th scope="row">NRIC</th>
            <td><span><c:out value="${callerInfo.nric }"/></span></td>
            <th scope="row">Company Name</th>
            <td><span><c:out value="${callerInfo.name }"/></span></td>
        </tr>
        <tr>
            <th scope="row">Contact(1)</th>
            <td><span><c:out value="${callerInfo.telM1 }"/></span></td>
            <th scope="row">Contact(2)</th>
            <td><span><c:out value="${callerInfo.telR }"/></span></td>
            <th scope="row">Email</th>
            <td><span><c:out value="${callerInfo.email }"/></span></td>
        </tr>
        </tbody>
        </table><!-- table end -->
    </article><!-- tap_area end -->
    <!-- Caller Info End -->

    </section><!-- tap_wrap end -->
</article><!-- tap_area end -->
<!-- Tag Info End -->

<!-- Respond Info Start -->
<article class="tap_area"><!-- tap_area start -->
    <aside class="title_line"><!-- title_line start -->
    <h3>Respond Info</h3>
    </aside><!-- title_line end -->

    <article class="grid_wrap"><!-- grid_wrap start -->
         <div id="respond_grid_wrap" style="width:100%; height:300px; margin:0 "></div>
    </article><!-- grid_wrap end -->

  
</article><!-- tap_area end -->
<!-- Respond Info End -->

</section><!-- tap_wrap end -->

<section class="search_table"><!-- search_table start -->

</section><!-- search_table end -->


<section class="search_result"><!-- search_result start -->



<article class="grid_wrap"><!-- grid_wrap start -->
  <aside class="title_line"><!-- title_line start -->
    <h3>Add Respond</h3>
    </aside><!-- title_line end -->
 
    <table class="type1"><!-- table start -->
  
    <caption>table</caption>
    <colgroup>
        <col style="width:180px" />
        <col style="width:*" />
    </colgroup>
   
    <tbody>
     <tr>
        <th scope="row">Main Dept</th>
        <td>
         <select class="w100p" id="inputMainDept" name="inputMainDept"></select>
         </td>
     </tr>
      <tr>
        <th scope="row">Sub Dept</th>
        <td><select class="w100p" id="inputSubDept" name="inputSubDept"></select></td>
     </tr>
    <tr>
        <th scope="row">Status</th>
        <td>
            <select  id="status" name="status">
                <option value="1">Active</option>
                <option value="44">Pending</option>
                <option value="34">Solve</option>
                <option value="35">Not yet to solve</option>
                <option value="36">Close</option>
                <option value="10">Cancel</option>
            </select>
        </td>
    </tr>
    <tr>
        <th scope="row">Remark</th>
        <td><textarea name="remark" id="remark" cols="20" rows="5" placeholder=""></textarea></td>
         
    </tr>
    
    </tbody>
    
    </table><!-- table end -->

    <ul class="right_btns">
    <li><p class="btn_grid"><a  id="remark" onclick="fn_saveRemarkResult()">Save</a></p></li>
</ul>
    
    
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- content end -->

</div>