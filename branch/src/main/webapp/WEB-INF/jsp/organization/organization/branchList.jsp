<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>



   <script type="text/javaScript" language="javascript">
   
        // AUIGrid 생성 후 반환 ID
        var myGridID;
        var gridValue;
        
        var option = {
            width : "1000px", // 창 가로 크기
            height : "600px" // 창 세로 크기
        };
    
   
        function f_multiCombo(){
           $(function() {
                  $('#branchType').change(function() {
                    }).multipleSelect({
                        selectAll: true,
                        width: '80%'
                    });
                    $('#region').change(function() {
                    }).multipleSelect({
                        selectAll: true,
                        width: '80%'
                    });     
                         
            });    
        }
        
        
            //Combo Data
        var statusTypeData = [{"codeId": "1","codeName": "Active"},{"codeId": "2","codeName": "Inactive"}];
        //doGetCombo('/common/selectCodeList.do', '45', '','branchType', 'M' , 'f_multiCombo'); //branchType
        doGetCombo('/common/selectCodeList.do', '49', '','region', 'M' , 'f_multiCombo'); //region
        doGetCombo('/common/selectCodeList.do', '45', '','branchType', 'M' , 'f_multiCombo'); //region
        
        
        // 화면 초기화 함수 (jQuery 의 $(document).ready(function() {}); 과 같은 역할을 합니다.
        $(document).ready(function(){
            
            //MemberType set 
            doDefCombo(statusTypeData, '' ,'cmbStatusType', 'S', '');  
            
            // AUIGrid 그리드를 생성합니다.
            createAUIGrid();
            AUIGrid.setSelectionMode(myGridID, "singleRow");
            
            AUIGrid.bind(myGridID, "cellClick", function(event) {
                brnchId =  AUIGrid.getCellValue(myGridID, event.rowIndex, "brnchId");
            }); 
            
            
           // 셀 더블클릭 이벤트 바인딩
            AUIGrid.bind(myGridID, "cellDoubleClick", function(event) {
                Common.popupDiv("/organization/getBranchViewPop.do?isPop=true&brnchId=" + AUIGrid.getCellValue(myGridID, event.rowIndex, "brnchId"), "");
            });
            
        });
    
        
        function fn_branchEditPop(){
            Common.popupDiv("/organization/getBranchDetailPop.do?isPop=true&brnchId=" + brnchId, "");
        }
    
        function createAUIGrid(){
            // AUIGrid 칼럼 설정
            var columnLayout = [ {
            
                        dataField : "codeName",
                        headerText : "Branch Type",
                        width : 190
                 }, {
                        dataField : "code",
                        headerText : "Branch Code",
                        width : 120,
                 }, {
                        dataField : "name",
                        headerText : "Branch Name",
                        width : 290,
                 }, {
                        dataField : "c11",
                        headerText : "Region",
                        width : 120,
                 }, {
                        dataField : "name1",
                        headerText : "Status",
                        width : 120,
                 /* }, {
                        dataField : "brnchId",
                        headerText : "brnch_Id",
                        width : 120,         */                
                 }];
            
            // 그리드 속성 설정
            var gridPros = {
                
                // 페이징 사용       
                usePaging : true,
                
                // 한 화면에 출력되는 행 개수 20(기본값:20)
                pageRowCount : 20,
                
                editable : false,
                
                showStateColumn : false, 
                
                displayTreeOpen : true,
                
                headerHeight : 30,
                
                // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
                skipReadonlyColumns : true,
                
                // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
                wrapSelectionMove : true,
                
                // 줄번호 칼럼 렌더러 출력
                showRowNumColumn : true,
        
            };
            
                        //myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout, gridPros);
                    myGridID = AUIGrid.create("#grid_wrap", columnLayout, gridPros);
        }
    

    
     // 리스트 조회.
        function fn_getBranchListAjax() {        
            Common.ajax("GET", "/organization/selectBranchList.do", $("#searchForm").serialize(), function(result) {
                
                console.log("성공.");
                console.log("data : " + result);
                AUIGrid.setGridData(myGridID, result);
            });     
        }
        
        
        
        //insert
        function fn_newBranch() {
            Common.popupDiv("/organization/branchNewPop.do?isPop=true", "");
        }
        
        function fn_excelDown(){
            // type : "xlsx", "csv", "txt", "xml", "json", "pdf", "object"
            GridCommon.exportTo("grid_wrap", "xlsx", "Branch List");
        }
        
    </script>
    


<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>Sales</li>
    <li>Order list</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>Branch Management</h2>
<ul class="right_btns">
<c:if test="${PAGE_AUTH.funcChange == 'Y'}">
    <li><p class="btn_blue"><a href="#" onclick="javascript:fn_newBranch();">New</a></p></li>
    <li><p class="btn_blue"><a href="#" onclick="javascript:fn_branchEditPop();">Edit</a></p></li>
</c:if>
<c:if test="${PAGE_AUTH.funcView == 'Y'}">
    <li><p class="btn_blue"><a href="#" onclick="javascript:fn_getBranchListAjax();"><span class="search"></span>Search</a></p></li>
</c:if>    
    <li><p class="btn_blue"><a href="#"><span class="clear"></span>Clear</a></p></li>
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form action="#" id= "searchForm"' method="post">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Branch Code</th>
    <td>
    <input type="text" title="" placeholder="Branch Code" class="w100p" id="branchCd" name="branchCd"/>
    </td>
    <th scope="row">Branch Name</th>
    <td>
    <input type="text" title="" placeholder="Branch Name" class="w100p" id="branchNm" name="branchNm"/>
    </td>
    <th scope="row">Status</th>
    <td>
    <select id="cmbStatusType" name="cmbStatusType" class="w100p">
        <option value="">Status</option>
    </select>
    </td>
</tr>
<tr>
    <th scope="row">Branch Type</th>
    <td>
    <select id="branchType" name="branchType" class="multy_select w100p" multiple="multiple">
        <option value="">Branch Type</option>
    </select>
    </td>
    <th scope="row">Region</th>
    <td>
    <select id="region" name="region" class="multy_select w100p" multiple="multiple">
        <option value="">Region</option>
    </select>
    </td>
    <th scope="row">Country</th>
    <td>
    <input type="text" title="" placeholder="Country" class="w100p" id="countryCd" name="countryCd"/>
    </td>
</tr>
<tr>
    <th scope="row">State</th>
    <td>
    <input type="text" title="" placeholder="State" class="w100p" id="state" name="state"/>
    </td>
    <th scope="row">Area</th>
    <td>
    <input type="text" title="" placeholder="Area" class="w100p" id="area" name="area"/>
    </td>
    <th scope="row">Postcode</th>
    <td>
    <input type="text" title="" placeholder="Postcode" class="w100p" id="postCode" name="postCode"/>
    </td>
</tr>
</tbody>
</table><!-- table end -->

<%-- <aside class="link_btns_wrap"><!-- link_btns_wrap start -->
<p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
<dl class="link_list">
    <dt>Link</dt>
    <dd>
    <ul class="btns">
        <li><p class="link_btn"><a href="#">menu1</a></p></li>
        <li><p class="link_btn"><a href="#">menu2</a></p></li>
        <li><p class="link_btn"><a href="#">menu3</a></p></li>
        <li><p class="link_btn"><a href="#">menu4</a></p></li>
        <li><p class="link_btn"><a href="#">Search Payment</a></p></li>
        <li><p class="link_btn"><a href="#">menu6</a></p></li>
        <li><p class="link_btn"><a href="#">menu7</a></p></li>
        <li><p class="link_btn"><a href="#">menu8</a></p></li>
    </ul>
    <ul class="btns">
        <li><p class="link_btn type2"><a href="#">menu1</a></p></li>
        <li><p class="link_btn type2"><a href="#">Search Payment</a></p></li>
        <li><p class="link_btn type2"><a href="#">menu3</a></p></li>
        <li><p class="link_btn type2"><a href="#">menu4</a></p></li>
        <li><p class="link_btn type2"><a href="#">Search Payment</a></p></li>
        <li><p class="link_btn type2"><a href="#">menu6</a></p></li>
        <li><p class="link_btn type2"><a href="#">menu7</a></p></li>
        <li><p class="link_btn type2"><a href="#">menu8</a></p></li>
    </ul>
    <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
    </dd>
</dl>
</aside><!-- link_btns_wrap end --> --%>

</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<ul class="right_btns">
<c:if test="${PAGE_AUTH.funcPrint == 'Y'}">
    <li><p class="btn_grid"><a href="#" onclick="javascript:fn_excelDown()">GENERATE</a></p></li>
</c:if>    
   <!--  <li><p class="btn_grid"><a href="#">EXCEL UP</a></p></li>
    <li><p class="btn_grid"><a href="#">EXCEL DW</a></p></li>
    <li><p class="btn_grid"><a href="#">DEL</a></p></li>
    <li><p class="btn_grid"><a href="#">INS</a></p></li>
    <li><p class="btn_grid"><a href="#">ADD</a></p></li>
    <li><p class="btn_grid"><a href=" javascript:fn_newBranch();">NEW</a></p></li> -->
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
      <div id="grid_wrap" style="width: 100%; height: 530px; margin: 0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- content end -->