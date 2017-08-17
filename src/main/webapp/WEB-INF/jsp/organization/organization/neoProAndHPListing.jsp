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
    
    
    //Combo Data
    var hpTypeData = [{"codeId": "0","codeName": "HP"},{"codeId": "1","codeName": "NEOPRO"}];
    var prev3MthData = [{"codeId": "0","codeName": "0"},{"codeId": "1","codeName": "1-2"},{"codeId": "2","codeName": "3-6"},{"codeId": "3","codeName": "=>7"}]
    var prev2MthData = [{"codeId": "0","codeName": "0"},{"codeId": "1","codeName": "1-2"},{"codeId": "2","codeName": "3-6"},{"codeId": "3","codeName": "=>7"}]
    var prev1MthData = [{"codeId": "0","codeName": "0"},{"codeId": "1","codeName": "1-2"},{"codeId": "2","codeName": "3-6"},{"codeId": "3","codeName": "=>7"}]
    
    var sortGbData = [{"codeId": "0","codeName": "Member Code"},{"codeId": "1","codeName": "Top OrgCode"},{"codeId": "2","codeName": "OrgCode"},{"codeId": "3","codeName": "GrpCode"}
                      ,{"codeId": "4","codeName": "DeptCode"},{"codeId": "5","codeName": "CurentNetSales"} ,{"codeId": "6","codeName": "TotalNetSales"}]
    
                                      
    // 화면 초기화 함수 (jQuery 의 $(document).ready(function() {}); 과 같은 역할을 합니다.
    $(document).ready(function(){
            
        doDefCombo(hpTypeData, '' ,'hpType', 'S', '');   
        doDefCombo(prev3MthData, '' ,'prev3Mth', 'S', '');
        doDefCombo(prev2MthData, '' ,'prev2Mth', 'S', '');
        doDefCombo(prev1MthData, '' ,'prev1Mth', 'S', '');
        
         doDefCombo(sortGbData, '' ,'sortGb', 'S', '');
         
        // AUIGrid 그리드를 생성합니다.
        createAUIGrid();
    
        AUIGrid.setSelectionMode(myGridID, "singleRow");
    
    
    });
    
    
        function createAUIGrid(){
        // AUIGrid 칼럼 설정
        var columnLayout = [ {
                    dataField : "memCode",
                    headerText : "Member Code",
                    width : 120
                }, {
                    dataField : "memName",
                    headerText : "Member  Name",
                    width : 120
                }, {
                    dataField : "topOrgCode",
                    headerText : "Top Org Code",
                    width : 120
                }, {
                    dataField : "orgCode",
                    headerText : "Org Code",
                    width : 120
                }, {
                    dataField : "grpCode",
                    headerText : "Grp Code",
                    width : 120
                }, {
                    dataField : "deptCode",
                    headerText : "Dept Code",
                    width : 120
                }, {
                    dataField : "joinDt",
                    headerText : "Join Date",
                    width : 120
                }, {
                    dataField : "prev3MthNet",
                    headerText : "Pre 3 Mth",
                    width : 120
                }, {
                    dataField : "prev2MthNet",
                    headerText : "Pre 2 Mth",
                    width : 120
                }, {
                    dataField : "prev1MthNet",
                    headerText : "Pre 1 Mth",
                    width : 120
                }, {
                    dataField : "totNet",
                    headerText : "Total Net Sales",
                    width : 120
                }, {
                    dataField : "curMthNet",
                    headerText : "Current Net Sales",
                    width : 120
            
            }];
            // 그리드 속성 설정
            var gridPros = {
                
                // 페이징 사용       
                usePaging : true,
                
                // 한 화면에 출력되는 행 개수 20(기본값:20)
                pageRowCount : 20,
                
                editable : true,
                
                showStateColumn : true, 
                
                displayTreeOpen : true,
                
                
                headerHeight : 30,
                
                // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
                skipReadonlyColumns : true,
                
                // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
                wrapSelectionMove : true,
                
                // 줄번호 칼럼 렌더러 출력
                showRowNumColumn : true,
        
            };
                myGridID = AUIGrid.create("#grid_wrap", columnLayout, gridPros);
    }
    


	// 그리드 초기화.
	function resetUpdatedItems() {
	     AUIGrid.resetUpdatedItems(myGridID, "a");
	 }
	 
	 
	 
    
    // 리스트 조회.
	function fn_getNeoProAndHPListAjax() {        
	    Common.ajax("GET", "/organization/selectNeoProAndHPList.do", $("#searchForm").serialize(), function(result) {
	        
	        console.log("성공.");
	        console.log("data : " + result);
	        AUIGrid.setGridData(myGridID, result);
	    });
	}
    
    
    
    
    
    </script>
    
    
    <section id="content"><!-- content start -->
	<ul class="path">
	    <li><img src="../images/common/path_home.gif" alt="Home" /></li>
	    <li>Organization</li>
	    <li>Organization Chart</li>
	</ul>
	
	<aside class="title_line"><!-- title_line start -->
	<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
	<h2>Neo Pro & HP Listing</h2>
	<ul class="right_btns">
	    <li><p class="btn_blue"><a href="#" onclick="javascript:fn_getNeoProAndHPListAjax();"><span class="search"></span>Search</a></p></li>
	</ul>
	</aside><!-- title_line end -->
	
	<section class="search_table"><!-- search_table start -->
	<form name ="searchForm" id = "searchForm" action="#" method="post">
	
	<table class="type1"><!-- table start -->
	<caption>table</caption>
	<colgroup>
	    <col style="width:155px" />
	    <col style="width:*" />
	    <col style="width:155px" />
	    <col style="width:*" />
	    <col style="width:155px" />
	    <col style="width:*" />
	</colgroup>
	<tbody>
	<tr>
	    <th scope="row">HP CODE</th>
	    <td>
	    <input type="text" title="" placeholder="" class="w100p" />
	    </td>
	    <th scope="row">HP Type</th>
	    <td>
	    <select id = "hpType" name = "hpType" class="w100p">
	    </select>
	    </td>
	    <th scope="row">TOPORGCODE</th>
	    <td>
	    <input type="text" title="" placeholder="" class="w100p" />
	    </td>
	</tr>
	<tr>
	    <th scope="row">ORGCODE</th>
	    <td>
	    <input type="text" title="" placeholder="" class="w100p" />
	    </td>
	    <th scope="row">GRPCODE</th>
	    <td>
	    <input type="text" title="" placeholder="" class="w100p" />
	    </td>
	    <th scope="row">DEPTCODE</th>
	    <td>
	    <input type="text" title="" placeholder="" class="w100p" />
	    </td>
	</tr>
	<tr>
	    <th scope="row">PREVIOUS 3 MTH</th>
	    <td>
	    <select id ="prev3Mth" name = "prev3Mth" class="w100p">
	    </select>
	    </td>
	    <th scope="row">PREVIOUS 2 MTH</th>
	    <td>
	    <select  id ="prev2Mth" name = "prev2Mth"  class="w100p">
	    </select>
	    </td>
	    <th scope="row">PREVIOUS 1 MTH</th>
	    <td>
	    <select  id ="prev1Mth" name = "prev1Mth" class="w100p">
	    </select>
	    </td>
	</tr>
	<tr>
	    <th scope="row">Sort By</th>
	    <td colspan="5">
	    <select  id ="sortGb" name = "sortGb" class="w100p">
	    </select>
	    </td>
	</tr>
	</tbody>
	</table><!-- table end -->
	
	<aside class="link_btns_wrap"><!-- link_btns_wrap start -->
	<p class="show_btn"><a href="#"><img src="../images/common/btn_link.gif" alt="link show" /></a></p>
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
	    <p class="hide_btn"><a href="#"><img src="../images/common/btn_link_close.gif" alt="hide" /></a></p>
	    </dd>
	</dl>
	</aside><!-- link_btns_wrap end -->
	
	</form>
	</section><!-- search_table end -->
	
	<section class="search_result"><!-- search_result start -->
	<ul class="right_btns">
	    <li><p class="btn_grid"><a href="#">EDIT</a></p></li>
	    <li><p class="btn_grid"><a href="#">NEW</a></p></li>
	    <li><p class="btn_grid"><a href="#">EXCEL UP</a></p></li>
	    <li><p class="btn_grid"><a href="#">EXCEL DW</a></p></li>
	    <li><p class="btn_grid"><a href="#">DEL</a></p></li>
	    <li><p class="btn_grid"><a href="#">INS</a></p></li>
	    <li><p class="btn_grid"><a href="#">ADD</a></p></li>
	</ul>
	
	<article class="grid_wrap"><!-- grid_wrap start -->
	그리드 영역
	    <div id="grid_wrap" style="width:100%; height:500px; margin:0 auto;"></div>\
	</article><!-- grid_wrap end -->
	
	</section><!-- search_result end -->
	
	</section><!-- content end -->