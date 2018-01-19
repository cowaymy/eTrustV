<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">
var gridID1;
var branchList = new Array();
function mileageCalSchemaResList() {
    var columnLayout = [
                          { dataField : "memType", headerText  : "Member Type",    width : 100 },
                          { dataField : "branchId", headerText  : "Branch Code",width : 100 },
                          { dataField : "memCode", headerText  : "Member Code",    width : 100 },
                          { dataField : "serviceDate", headerText  : "Service Date",    width : 100 },
                          { dataField : "totalDistance", headerText  : "Total Distance",    width : 100 },
                          { dataField : "mileage",       headerText  : "Mileage Amount",  width  : 200},
       ];

        var gridPros = { usePaging : true,  pageRowCount: 20, editable: false, selectionMode : "singleRow",  showRowNumColumn : true, showStateColumn : false};

        gridID1 = GridCommon.createAUIGrid("calculation_schema_result_grid_wap", columnLayout  ,"" ,gridPros);
    }

function f_multiCombo() {
    $(function() {

        $('#branch').change(function() {
        }).multipleSelect({
            selectAll : true,
            width : '80%'
        });
     


    });
}
$(document).ready(function(){
	mileageCalSchemaResList();

	$("#memType").change(function (){
		var memType = $("#memType").val();
		if(memType == 2){
			 doGetCombo('/services/mileageCileage/selectBranch', 42, '','branch', 'M' ,  'f_multiCombo');
			// doGetCombo('/services/mileageCileage/selectMemberCode', 2, '','memCode', 'M' ,  'f_multiCombo');
		}else if(memType == 3){
			doGetCombo('/services/mileageCileage/selectBranch', 43, '','branch', 'M' ,  'f_multiCombo');
			//GetCombo('/services/mileageCileage/selectMemberCode', 3, '','memCode', 'M' ,  'f_multiCombo');
		}
	 });
});

function fn_resultSearch(){
	if($("#month").val() == "" || typeof($("#month").val()) == "undefined"){
        Common.alert("<spring:message code='sys.msg.necessary' arguments='Period' htmlEscape='false'/>");
        return;
    }
	 
	Common.ajax(
		    "GET",
		    "/services/mileageCileage/selectSchemaResultMgmt.do",
		    $("#schemaResultForm").serialize() ,
		    function(result) {
		        console.log("성공.");
		        console.log("data : " + result);
		        AUIGrid.setGridData(gridID1, result);
		    }
    );
}

function fn_excelDown(){
    // type : "xlsx", "csv", "txt", "xml", "json", "pdf", "object"
    GridCommon.exportTo("calculation_schema_result_grid_wap", "xlsx", "MemberList");
}
</script>
<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>Sales</li>
    <li>Mileage Claim Master</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>Mileage Claim Master</h2>
<ul class="right_btns"><!--javascript:fn_resultSearch()  -->
<c:if test="${PAGE_AUTH.funcView == 'Y'}">
    <li><p class="btn_blue"><a onclick="fn_resultSearch()"><span class="search"></span>Search</a></p></li>
</c:if>    
    <li><p class="btn_blue"><a href="#"><span class="clear"></span>Clear</a></p></li>
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id="schemaResultForm">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Member Type</th>
    <td>
    <select class="w100p" id="memType" name="memType">
        <option value="2">CODY</option>
        <option value="3">CT</option>
    </select>
    </td>
    <th scope="row"></th>
    <td></td>
    <th scope="row"></th>
    <td></td>
</tr>
<tr>
    <th scope="row">Period<span class="must">*</span></th>
    <td><input type="text" title="Period" class="j_date2 w100p"  id="month" name="month"/></td>
    <th scope="row">Branch</th>
    <td>
        <div class="search_100p"><!-- search_100p start -->
        <select class="multy_select w100p" multiple="multiple"id="branch" name="branch">
            <%-- <c:forEach var="list" items="${branchList}">
             <option value="${list.codeId}">${list.codeName}</option>
         </c:forEach> --%>
        </select>
        </div><!-- search_100p end -->
    </td>
    <th scope="row">Member Code</th>
    <td>
        
        <input class="w100p"  id="memCode" name="memCode" />
       
    </td>
</tr>
</tbody>
</table><!-- table end -->

<ul class="right_btns">
<c:if test="${PAGE_AUTH.funcPrint == 'Y'}">
    <li><p class="btn_grid"><a href="#" onclick="javascript:fn_excelDown()"><spring:message code='service.btn.Generate' /></a></p></li></a></p></li>
</c:if>    
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="calculation_schema_result_grid_wap" style="width:100%; height:300px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</form>
</section><!-- search_table end -->

</section><!-- content end -->

