<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript" language="javascript">
        
        $(document).ready(function() {
        
          /*   doGetCombo('/services/holiday/selectBranchWithNM', 43, '','code', 'S' ,  '');
            
            doGetCombo('/services/tagMgmt/selectMainDept.do', '' , '', 'searchdepartment' , 'S', '');
    
            $("#searchdepartment").change(function(){
	         
            doGetCombo('/services/tagMgmt/selectSubDept.do',  $("#searchdepartment").val(), '','inputSubDept', 'S' ,  ''); 
	         
	     }); */
 	     
	     $("#salesOrdNo").focusout(function(){
             
             if (  $("#salesOrdNo").val().length > 6) {
             
             Common.ajax("GET", "/services/compensation/selectSalesOrdNoInfo.do",   { salesOrdNo :  $("#salesOrdNo").val() }  , function(result) {
                console.log("selectSalesOrdNoInfo >>> .");
                console.log(  JSON.stringify(result));
                
                 $("#product").val(result[0].stkDesc)
                 $("#Installation").val(result[0].installDt)
                 $("#Serial").val(result[0].serialNo)
                 $("#custId").val(result[0].custId)
              
            }); 
             }
         }); 
        setInputFile2();
   
        });
 
     function setInputFile2(){//인풋파일 세팅하기
                $(".auto_file2").append("<label><input type='text' class='input_text' readonly='readonly' /><span class='label_text'><a href='#'>File</a></span></label><span class='label_text'><a href='#'>Add</a></span><span class='label_text'><a href='#'>Delete</a></span>");
    }
 
    function fn_close() {
        $("#popClose").click();
    }       

    function fn_doSave () {
            
            if ($("#custId").val().trim() == '') {
                alert('Customer name checked');
                return false;
            } else if ($("#salesOrdNo").val().trim() == '') {
                alert('Order No checked');
                return false;
            } else if ($("#issueDt").val().trim() == '') {
                alert('AS Request Date checked');
                return false;
            } else {

	           var formData = Common.getFormData("comPensationInfoForm");
	             
	           var obj = $("#comPensationInfoForm").serializeJSON();
	             
	             $.each(obj, function(key, value) {
	                formData.append(key, value);
	            });
	             
	            console.log(JSON.stringify(formData));
	             
	            Common.ajaxFile("/services/compensation/insertCompensation.do",  formData , function(result) {
					console.log("fn_doSave >>> .");
					console.log(  JSON.stringify(result));
	                
	                if(result.code = "00"){
	                    $("#popClose").click();
	                    fn_searchASManagement();
	                     Common.alert("<b>Compensation successfully added.</b>",fn_close);
	               }else{
	                    Common.alert("<b>Failed to add this Compensation. Please try again later.</b>");
	               }			
	
	            }); 
            }
    }


function fn_getASReasonCode2(_obj , _tobj, _v){
    
    var   reasonCode =$(_obj).val();
    var   reasonTypeId =_v;
    
    Common.ajax("GET", "/services/as/getASReasonCode2.do", {RESN_TYPE_ID: reasonTypeId  ,CODE:reasonCode} , function(result) {
        console.log("fn_getASHistoryInfo.");
        console.log(  JSON.stringify(result));
        
        if(result.length >0 ){
            $("#"+_tobj+"_text").val((result[0].resnDesc.trim()).trim());
            $("#"+_tobj+"_id").val(result[0].resnId);
            
        }else{
            $("#"+_tobj+"_text").val("* No such detail of defect found.");
        }
    });
    
}
</script>


<body>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Add Compensation Log Detail</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->
<form action="#" method="post"  id='comPensationInfoForm' enctype="multipart/form-data">

<aside class="title_line"><!-- title_line start -->
<h2>General</h2>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:165px" />
    <col style="width:*" />
    <col style="width:165px" />
    <col style="width:*" />    
</colgroup>
<tbody>
<tr>
    <th scope="row">AS Request Date</th>
    <td colspan="3">
    <%-- <input type="text" title="" id="issueDt" name="issueDt"  value="${compensationView.issueDt}" placeholder="" class="readonly " style="width: 157px; " /> --%>
    <input type="text" title="Create start Date" placeholder="DD/MM/YYYY" name="issueDt" id="issueDt" class="j_date" " />
    </td>
    <th scope="row">Application Route</th>
    <td colspan="3">
    <input type="text" title="" id="asReqsterTypeId" name="asReqsterTypeId"  placeholder="" class=" " style="width: 157px; "/>
    </td>
</tr>
<tr>
    <th scope="row"> AS Order Number</th>
    <td colspan="3">
    <input type="text" title="" id="asNo" name="asNo" placeholder="" class=" " style="width: 157px; "/>
    </td>
    <th scope="row">Order No</th>
    <td colspan="3">
    <input type="text" title="" id="salesOrdNo" name="salesOrdNo"  placeholder="" class=" " style="width: 157px;" />
    </td>
</tr>
<tr>
 <th scope="row">Customer ID</th>
    <td colspan="3">
        <input type="text" title="" id="custId" name="custId" placeholder="" class="readonly" style="width: 157px; "/>
    </td>
    <th scope="row">Product name</th>
    <td colspan="3">
        <input type="text" title="" id="product" name="product"  placeholder="" class="readonly " readonly="readonly" style="width: 157px; "/>
    </td> 
</tr>

<tr>
    <th scope="row">Installation Date</th>
    <td colspan="3">
    <input type="text" title="" id="Installation" name="Installation"  placeholder="" class="readonly " readonly="readonly" style="width: 157px; "/>
    </td>
    <th scope="row">Serial No</th>
    <td colspan="3">
    <input type="text" title="" id="Serial" name="Serial"  placeholder="" class="readonly" readonly="readonly" style="width: 157px; "/>
    </td>
</tr>

<tr>
    <th scope="row">Status</th>
    <td colspan="3">
         <select  class="multy_select w100p" id="stusCodeId" name="stusCodeId">
                 <option value="1">Active</option>
                <option value="44">Pending</option>
                <option value="34">Solved</option>
                <option value="35">Unsolved</option>
                <option value="36">Closed</option>
                <option value="10">Cancelled</option>
        </select> 
    </td>  
    <th scope="row">Complete Date</th>
    <td colspan="3">
    <%-- <input type="date" title="" id="compDt" name="compDt" class="j_date2" value="${compensationView.compDt}" placeholder="" class="readonly "  style="width: 157px; "/> --%>
    <input type="text" title="Create start Date" placeholder="DD/MM/YYYY" name="compDt" id="compDt" class="j_date"/>
    </td>
</tr>
<tr>
    <th scope="row">RM</th>
    <td colspan="3">
    <input type="text" title="" id="compTotAmt" name="compTotAmt"  placeholder="" class=" " style="width: 157px; "/>
    </td>
    <th scope="row">Managing Department</th>
    <td colspan="3">
    <select class="w100p" id="searchdepartment" name="searchdepartment"  >
         <c:forEach var="list" items="${mainDeptList}" varStatus="status">
             <option value="${list.codeId}">${list.codeName } </option>
        </c:forEach>  
    </select>
    <!-- <select class="w100p" id="inputSubDept" name="inputSubDept"></select> -->
    </td>   
</tr>
<tr>
<th scope="row">DSC</th>
    <td colspan="3">
     <select id="code" name="code" class="w100p" >
          <c:forEach var="list" items="${branchWithNMList}" varStatus="status">
             <option value="${list.codeId}">${list.codeName } </option>
        </c:forEach>
     </select>
</td>
<th scope="row"></th>
<td colspan="3"> </td> 
</tr>     
</tr>
</tbody>
</table><!-- table end -->
 
<aside class="title_line"><!-- title_line start -->
<h2>Detail Log</h2>
</aside><!-- title_line end -->

  
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:165px" />
    <col style="width:*" />
    <col style="width:165px" />
    <col style="width:*" />    
</colgroup>
<tbody>
<tr>
    <th scope="row">Defect Parts</th>
    <td colspan="3">
    <!-- <input type="text" title="" id="asrItmPartId" name="asrItmPartId" placeholder="" class="readonly " style="width: 157px; " /> -->
	<input type="text" title=""  id='asrItmPart' name ='asrItmPart' placeholder="ex) DT3" class=""  onChange="fn_getASReasonCode2(this, 'asrItmPart' ,'387')" />
	<input type="hidden" title=""  id='asrItmPart_id'    name ='asrItmPart_id' placeholder="" class="" />
	<input type="text" title="" placeholder="" id='asrItmPart_text' name ='asrItmPart_text'   class="" />
    
    </td>
    <th scope="row">Leaking/burning</th>
    <td colspan="3">
    <input type="text" title="" id="asDefectTypeId" name="asDefectTypeId"  placeholder="" class=" " style="width: 157px; "/>
    </td>
</tr>
<tr>
    <th scope="row">Settlement Method</th>
    <td colspan="3">
	<input type="text" title="" placeholder="ex) A9" class=""  id='asSlutnResn' name ='asSlutnResn'  onChange="fn_getASReasonCode2(this, 'asSlutnResn'  ,'337')"   />
	<input type="hidden" title="" placeholder="" class=""   id='asSlutnResn_id' name ='asSlutnResn_id'  />
	<input type="text" title="" placeholder="" class=""   id='asSlutnResn_text' name ='asSlutnResn_text'  />
    </td>
    <th scope="row">Reason</th>
    <td colspan="3">
    <input type="text" title="" id="asMalfuncResnId" name="asMalfuncResnId"  placeholder="" class=" " style="width: 157px; "/>
    </td>
</tr>
<tr>
    <th scope="row">Compensation Item</th>
    <td colspan="3">
        <input type="text" title="" id="compItem1" name="compItem1"   placeholder="" class=" " style="width: 157px; "/>
    </td>
    <th scope="row">Compensation Item</th>
    <td colspan="3">
    <input type="text" title="" id="compItem2" name="compItem2"   placeholder="" class=" " style="width: 157px; "/>
    </td>
</tr>
<tr>


    <th scope="row">Compensation Item</th>
    <td colspan="7">
    <input type="text" title="" id="compItem3" name="compItem3"   placeholder="" class=" " style="width: 157px; "/>
    </td> 
</tr>
 <tr>
    <th scope="row">attachment</th>
    <td colspan="7">
    <div class="auto_file2 attachment_file w100p"><!-- auto_file start -->
    <input type="file" title="file add" style="width:300px" />
    </div><!-- auto_file end -->
    </td>
</tr>
</tbody>
</table><!-- table end -->
    

  
</form>

<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#"  onclick="fn_doSave()">Save</a></p></li>
</ul>

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->

</body>