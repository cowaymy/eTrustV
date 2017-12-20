<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">
var myGridID_order;
var complianceList;
$(document).ready(function(){
         
            var reqstCtgry = "${guardianofCompliance.reqstCtgry}";
            $("#caseCategory option[value='"+ reqstCtgry +"']").attr("selected", true);
            
            var reqstCtgrySub = "${guardianofCompliance.reqstCtgrySub}";
            $("#docType option[value='"+ reqstCtgrySub +"']").attr("selected", true);	
	  
});
 
</script>
<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Guardian of Compliance New</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->


<article class="tap_area"><!-- tap_area start -->
<form action="#" method="post" id="saveForm">
<input type="hidden" title="" placeholder="" class="" id="memberId" name="memberId"/>
<input type="hidden" title="" placeholder="" class="" id="hidFileName" name="hidFileName"/>

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:110px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Case Category</th>
    <td colspan="3">
        <select class="w100p disabled" id="caseCategory" name="caseCategory" disabled="disabled"">
	         <c:forEach var="list" items="${caseCategoryCodeList}" varStatus="status">
	             <option value="${list.codeId}">${list.codeName } </option>
	        </c:forEach> 
        </select>
    </td>
    <th scope="row">Types of Documents</th> 
    <td colspan="3">
    <select class="w100p disabled" disabled="disabled" id="docType" name="docType">
             <c:forEach var="list" items="${documentsCodeList}" varStatus="status">
                 <option value="${list.codeId}">${list.codeName } </option>
            </c:forEach>     
    </select>
    </td>
</tr>
<tr>
    <th scope="row">Customer Name</th>
    <td colspan="3">
    <input type="text" title="" placeholder="Customer Name"" name="customerName" id="customerName" class="readonly " style="width:257px;" readonly="readonly" value="${guardianofCompliance.reqstCrtUserId}"/>
    </td>
    <th scope="row">Order No</th>
    <td colspan="3">
        <%-- <input type="text" title="" placeholder="Order No" class="" id="salesOrdNo" name="salesOrdNo" class="readonly "  readonly="readonly"  value="${guardianofCompliance.reqstOrdId}"/> --%>
        <input type="text" title="" placeholder="Order No" name="salesOrdNo" id="salesOrdNo" class="readonly "  readonly="readonly" value="${guardianofCompliance.reqstOrdId}"/>
    </td>
</tr>
<tr>
    <th scope="row">Customer Contact</th>
    <td colspan="3">
    <input type="text" title="" placeholder="Customer Contact"" name="reqstCntnt" id="reqstCntnt" class="readonly "  readonly="readonly" value="${guardianofCompliance.reqstRem}"/>
    </td>
    <th scope="row">Complaint Date</th>
    <td colspan="3">
      <input type="text" title="Complaint Date" placeholder="DD/MM/YYYY" name="reqstRefDt" id="reqstRefDt" class="readonly "  readonly="readonly"  class="j_date" value="${guardianofCompliance.reqstRefDt}"/>
    </td>
</tr>
<tr>
    <th scope="row">Involved Person Code</th>
    <td colspan="7">
    <input type="text" title="" placeholder="Involved Person Code"" name="reqstMemId" id="reqstMemId" class="readonly "  readonly="readonly" value="${guardianofCompliance.reqstMemId}"/>
    </td>
</tr>
<tr>
    <th scope="row">Complaint Content</th>
    <td colspan="7">
    <textarea cols="20" rows="5" placeholder="Complaint Content" id="complianceRem"  readonly="readonly"  class="readonly"  name="complianceRem">${guardianofCompliance.reqstCntnt}</textarea>
    </td>
</tr>
</tbody>
</table><!-- table end -->
</form>

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->
 
</section><!-- pop_body end -->

</div><!-- popup_wrap end -->
