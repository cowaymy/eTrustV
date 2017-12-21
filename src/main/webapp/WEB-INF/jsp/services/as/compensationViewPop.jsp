<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript" language="javascript">
        
        $(document).ready(function() {
        
	       $("#searchdepartment").change(function(){
	         
	         doGetCombo('/services/tagMgmt/selectSubDept.do',  $("#searchdepartment").val(), '','inputSubDept', 'S' ,  ''); 
	         
	     });
	     
	        var statusCd = "${compensationView.stusCodeId}";
            $("#stusCodeId option[value='"+ statusCd +"']").attr("selected", true);
            
            var searchdepartmentStatusCd = "${compensationView.mainDept}";
            $("#searchdepartment option[value='"+ searchdepartmentStatusCd +"']").attr("selected", true);
            
            var codeStatusCd = "${compensationView.code}";
            $("#code option[value='"+ codeStatusCd +"']").attr("selected", true);
	     
            
            /*AttachFile values*/
            $("input[name=attachFile]").on("dblclick", function () {

                Common.showLoader();

                var $this = $(this);
                var fileId = $this.attr("data-id");

                $.fileDownload("${pageContext.request.contextPath}/file/fileDown.do", {
                    httpMethod: "POST",
                    contentType: "application/json;charset=UTF-8",
                    data: {
                        fileId: fileId
                    },
                    failCallback: function (responseHtml, url, error) {
                        Common.alert($(responseHtml).find("#errorMessage").text());
                    }
                })
                    .done(function () {
                        Common.removeLoader();
                        console.log('File download a success!');
                    })
                    .fail(function () {
                        Common.removeLoader();
                    });
                return false; //this is critical to stop the click event which will trigger a normal file download
            });
            
        });
 
    function fn_close() {
        $("#popClose").click();
    }       

</script>


<body>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>View Compliance Log Detail</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->
<form action="#" method="get"  id='comPensationInfoForm'>
    <input type="hidden" name="compNo"  id="compNo" value="${compNo}"/>

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
    <input type="text" title="" id="issueDt" name="issueDt"  value="${compensationView.issueDt}" placeholder="" class="readonly " style="width: 157px; "/>
    </td>
    <th scope="row">Application Route</th>
    <td colspan="3">
    <input type="text" title="" id="asReqsterTypeId" name="asReqsterTypeId"  readonly="readonly" value="${compensationView.asReqsterTypeId}" placeholder="" class="readonly " style="width: 157px; "/>
    </td>
</tr>
<tr>
    <th scope="row"> AS Order Number</th>
    <td colspan="3">
    <input type="text" title="" id="asNo" name="asNo"  value="${compensationView.asNo}" placeholder="" class="readonly " style="width: 157px; "/>
    </td>
    <th scope="row">Order No</th>
    <td colspan="3">
    <input type="text" title="" id="salesOrdNo" name="salesOrdNo"  readonly="readonly" value="${compensationView.salesOrdNo}" placeholder="" class="readonly " style="width: 157px; "/>
    </td>
</tr>
<tr>
 <th scope="row">Customer name</th>
    <td colspan="3">
        <input type="text" title="" id="custId" name="custId"  readonly="readonly" value="${compensationView.custId}" placeholder="" class="readonly " style="width: 157px; "/>
    </td>
    <th scope="row">Product name</th>
    <td colspan="3">
        <input type="text" title="" id="product" name="product"  value="${compensationView.stkDesc}" placeholder="" class="readonly " readonly="readonly" style="width: 157px; "/>
    </td> 
</tr>

<tr>
    <th scope="row">Installation Date</th>
    <td colspan="3">
    <input type="text" title="" id="Installation" name="Installation"  value="${compensationView.installDt}" placeholder="" class="readonly " readonly="readonly" style="width: 157px; "/>
    </td>
    <th scope="row">Serial No</th>
    <td colspan="3">
    <input type="text" title="" id="Serial" name="Serial"  value="${compensationView.serialNo}" placeholder="" class="readonly " readonly="readonly" style="width: 157px; "/>
    </td>
</tr>

<tr>
    <th scope="row">Status</th>
    <td colspan="3">
         <select  class="multy_select w100p" id="stusCodeId" name="stusCodeId" disabled="disabled">
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
    <input type="text" title="" id="compDt" name="compDt"  value="${compensationView.compDt}" placeholder="" class="readonly " readonly="readonly" style="width: 157px; "/>
    </td>
</tr>
<tr>
    <th scope="row">RM</th>
    <td colspan="3">
    <input type="text" title="" id="compTotAmt" name="compTotAmt"  readonly="readonly" value="${compensationView.compTotAmt}" placeholder="" class="readonly " style="width: 157px; "/>
    </td>
    <th scope="row">Managing Department</th>
    <td colspan="3">
    <%-- <input type="text" title="" id="mainDept" name="mainDept"  value="${compensationView.mainDept}" placeholder="" class="readonly " style="width: 157px; "/> --%>
    <select class="w100p" id="searchdepartment" name="searchdepartment"  disabled="disabled">
        <c:forEach var="list" items="${mainDeptList}" varStatus="status">
             <option value="${list.codeId}">${list.codeName } </option>
        </c:forEach>  
    </select>
    <!-- <select class="w100p" id="inputSubDept" name="inputSubDept" disabled="disabled"></select> -->
    </td>   
</tr>
<tr>
<th scope="row">DSC</th>
    <td colspan="3">
     <select id="code" name="code" class="w100p" disabled="disabled">
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
    <input type="text" title="" id="asrItmPartId" name="asrItmPartId"  value="${compensationView.asrItmPartId}" readonly="readonly" placeholder="" class="readonly " style="width: 157px; " />
    </td>
    <th scope="row">Leaking/burning</th>
    <td colspan="3">
    <input type="text" title="" id="asDefectTypeId" name="asDefectTypeId"  value="${compensationView.asDefectTypeId}" readonly="readonly" placeholder="" class="readonly " style="width: 157px; "/>
    </td>
</tr>
<tr>
    <th scope="row">Settlement Method</th>
    <td colspan="3">
    <input type="text" title="" id="asMalfuncResnId" name="asMalfuncResnId"  value="${compensationView.asMalfuncResnId}" readonly="readonly" placeholder="" class="readonly " style="width: 157px; "/>
    </td>
    <th scope="row">Reason</th>
    <td colspan="3">
    <input type="text" title="" id="asMalfuncResnId" name="asMalfuncResnId"  value="${compensationView.asMalfuncResnId}" readonly="readonly" placeholder="" class="readonly " style="width: 157px; "/>
    </td>
</tr>
<tr>
    <th scope="row">Compensation Item</th>
    <td colspan="3">
        <input type="text" title="" id="compItem1" name="compItem1"  value="${compensationView.compItem1}" readonly="readonly" placeholder="" class="readonly " style="width: 157px; "/>
    </td>
    <th scope="row">Compensation Item</th>
    <td colspan="3">
    <input type="text" title="" id="compItem2" name="compItem2"  value="${compensationView.compItem2}" readonly="readonly" placeholder="" class="readonly " style="width: 157px; "/>
    </td> 
</tr>
<tr>
    <th scope="row">Compensation Item</th>
    <td colspan="3">
    <input type="text" title="" id="compItem3" name="compItem3"  value="${compensationView.compItem3}" readonly="readonly" class="readonly " style="width: 157px; "/>
    </td> 
    <th scope="row"></th>
    <td colspan="3">
    </td> 
</tr>
 <tr>
    <th scope="row">Attachment</th>
    <td colspan="7">
        <c:forEach var="fileInfo" items="${files}" varStatus="status">
            <div class="auto_file2"><!-- auto_file start -->
                <input title="file add" style="width: 300px;" type="file">
                    <label>
                        <input type='text' class='input_text' readonly='readonly' name="attachFile"
                                  value="${fileInfo.atchFileName}" data-id="${fileInfo.atchFileId}"/>
                    </label>
            </div>
       </c:forEach>
    </td>
 </tr>
</tbody>
</table><!-- table end -->
    

  
</form>


</section><!-- pop_body end -->

</div><!-- popup_wrap end -->

</body>