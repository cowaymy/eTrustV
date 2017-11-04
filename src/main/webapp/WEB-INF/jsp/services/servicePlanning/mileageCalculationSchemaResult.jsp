<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">
var gridID1;
function mileageCalSchemaResList() { 
    var columnLayout = [
                          { dataField : "memType", headerText  : "Member Type",    width : 100 },
                          { dataField : "branchId", headerText  : "Branch Code",width : 100 },
                          { dataField : "memCode", headerText  : "Member Code",    width : 100 },
                          { dataField : "serviceDate", headerText  : "Service Date",    width : 100 },
                          { dataField : "totalDistance", headerText  : "Total Distance",    width : 100 },
                          { dataField : "mileage Amount",       headerText  : "Mileage Amount",  width  : 200},
       ];

        var gridPros = { usePaging : true,  pageRowCount: 20, editable: true, selectionMode : "singleRow",  showRowNumColumn : true, showStateColumn : false};  
        
        gridID1 = GridCommon.createAUIGrid("calculation_schema_result_grid_wap", columnLayout  ,"" ,gridPros);
    }
    
$(document).ready(function(){
	mileageCalSchemaResList();
});

function fn_resultSearch(){
	Common.ajax("GET", "/services/mileageCileage/selectSchemaResultMgmt.do",$("#schemaResultForm").serialize() , function(result) {
        console.log("성공.");
        console.log("data : " + result);
        AUIGrid.setGridData(gridID1, result);
    });
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
<ul class="right_btns">
    <li><p class="btn_blue"><a href="#" onclick="javascript:fn_resultSearch()"><span class="search"></span>Search</a></p></li>
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
    <select class="multy_select w100p" multiple="multiple" id="memType" name="memType">
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
    <th scope="row">Period</th>
    <td><input type="text" title="기준년월" class="j_date2 w100p"  id="month" name="month"/></td>
    <th scope="row">Branch</th>
    <td>
        <div class="search_100p"><!-- search_100p start -->
        <select class="multy_select w100p" multiple="multiple"id="branch" name="branch">
            <c:forEach var="list" items="${branchList}">
             <option value="${list.codeId}">${list.codeName}</option>
         </c:forEach> 
        </select>
        </div><!-- search_100p end -->
    </td>
    <th scope="row">Member Code</th>
    <td>
        <div class="search_100p"><!-- search_100p start -->
        <input type="text" title="" placeholder="" class="w100p" id="memCode" name="memCode"/>
        </div><!-- search_100p end -->
    </td>
</tr>
</tbody>
</table><!-- table end -->

<ul class="right_btns">
    <li><p class="btn_grid"><a href="#">EXCEL DW</a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="calculation_schema_result_grid_wap" style="width:100%; height:300px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</form>
</section><!-- search_table end -->

</section><!-- content end -->

