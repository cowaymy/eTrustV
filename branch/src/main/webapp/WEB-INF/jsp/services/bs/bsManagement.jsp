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
     var bSStatusData = [{"codeId": "1","codeName": "Active"},{"codeId": "2","codeName": "Completed"},{"codeId": "3","codeName": "Failed"},{"codeId": "4","codeName": "Cancelled"}];
        

 // 화면 초기화 함수 (jQuery 의 $(document).ready(function() {}); 과 같은 역할을 합니다.
    $(document).ready(function(){
            
            $('#mypBSMonth').val($.datepicker.formatDate('mm/yy', new Date()));
            
            //BS Status set 
            doDefCombo(bSStatusData, '' ,'ddlBSStatus', 'S', '');  
            
            
            
        // AUIGrid 그리드를 생성합니다.
        createAUIGrid();
        
        AUIGrid.setSelectionMode(myGridID, "singleRow");
        
/*                 // 셀 더블클릭 이벤트 바인딩
        AUIGrid.bind(myGridID, "cellDoubleClick", function(event) {
//            fn_setDetail(myGridID, event.rowIndex);
            Common.popupWin("searchForm", "/organization/getMemberEventDetailPop.do?isPop=true&promoId=" + AUIGrid.getCellValue(myGridID, event.rowIndex, "promoId"), option);
        }); */
        

    });    
    
    
    function createAUIGrid(){
        // AUIGrid 칼럼 설정
        var columnLayout = [ {
                    dataField : "no",
                    headerText : "BS No",
                    width : 120
                }, {
                    dataField : "month",
                    headerText : "BS Month",
                    width : 120
                }, {
                    dataField : "year",
                    headerText : "BS Year",
                    width : 120
                }, {
                    dataField : "code",
                    headerText : "BS Status",
                    width : 120
                }, {
                    dataField : "",
                    headerText : "Result No",
                    width : 120
                }, {
                    dataField : "salesOrdNo",
                    headerText : "Order No",
                    width : 120
                }, {
                    dataField : "code1",
                    headerText : "App Type",
                    width : 120
                }, {
                    dataField : "name",
                    headerText : "Customer Name",
                    width : 120
                }, {
                    dataField : "c5",
                    headerText : "Assign Member",
                    width : 120
                }, {
                    dataField : "c8",
                    headerText : "Action Member",
                    width : 120
                }, {
                    dataField : "instState",
                    headerText : "State",
                    width : 120
                }, {
                    dataField : "instArea",
                    headerText : "Area",
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
                    //myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout, gridPros);
                myGridID = AUIGrid.create("#grid_wrap", columnLayout, gridPros);
    }
    
    
    
    
         // 리스트 조회.
        function fn_getBSListAjax() {        
            Common.ajax("GET", "/bs/selectBsManagementList.do", $("#searchForm").serialize(), function(result) {
                
                console.log("성공.");
                console.log("data : " + result);
                AUIGrid.setGridData(myGridID, result);
            });     
        }
    
    
    
    
    
    
    
    </script>
    

<form id="searchForm" name="searchForm">    
<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="../images/common/path_home.gif" alt="Home" /></li>
    <li>Sales</li>
    <li>Order list</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>HS Management</h2>
<ul class="right_btns">
    <li><p class="btn_blue"><a href="#" " onclick="javascript:fn_getBSListAjax();" ><span class="search"></span>Search</a></p></li>
    <li><p class="btn_blue"><a href="#"><span class="clear"></span>Clear</a></p></li>
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form action="#" method="post">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:140px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:160px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Order Number</th>
    <td><input id="txtOrderNo" name="txtOrderNo"  type="text" title="" placeholder="Order Number" class="w100p" /></td>
    <th scope="row">BS Number</th>
    <td><input id="txtBSNo" name="txtBSNo"  type="text" title="" placeholder="BS Number" class="w100p" /></td>
    <th scope="row">BS Month</th>
    <td><input id="mypBSMonth" name="mypBSMonth" type="text" title="기준년월" placeholder="MM/YYYY" class="j_date2 w100p" readonly /></td>
</tr>
<tr>
    <th scope="row">Result Number</th>
    <td><input type="text" title="" placeholder="esult Number" class="w100p" /></td>
    <th scope="row">BS Status</th>
    <td>
    <select  id="ddlBSStatus" name="ddlBSStatus" class="multy_select w100p" multiple="multiple">
        <option value="">BS Status</option>
    </select>
    </td>
    <th scope="row">Assigned Member</th>
    <td><input type="text" title="" placeholder="Assigned Member" class="w100p" /></td>
</tr>
<tr>
    <th scope="row">Install State</th>
    <td>
    <select  id="cmbState" name="cmbState" class="w100p">
        <option value="" selected>Install State</option>
             <c:forEach var="list" items="${bsStateList }" varStatus="status">
               <option value="${list.stateId}">${list.name}</option>
            </c:forEach>
    </select>
    </td>
    <th scope="row">Install Area</th>
    <td>
    <select  id="cmbArea" name="cmbArea"  class="w100p">
        <option value="" selected>Install Area</option>
            <c:forEach var="list" items="${areaList }" varStatus="status">
               <option value="${list.c1}">${list.areaName}</option>
            </c:forEach>
    </select>
    </td>
    <th scope="row">Install Month</th>
    <td><input id="mypInstallMonth" name="mypInstallMonth" type="text" title="기준년월" placeholder="MM/YYYY" class="j_date2 w100p"  /></td>
</tr>
<tr>
    <th scope="row">Ineffective Cody</th>
    <td><label><input type="checkbox" /><span></span></label></td>
    <th scope="row">Action Member</th>
    <td><input type="text" title="" placeholder="Assigned Member" class="w100p" /></td>
    <th scope="row"></th>
    <td></td>
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
    <div id="grid_wrap" style="width: 100%; height: 334px; margin: 0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- content end -->
</form>