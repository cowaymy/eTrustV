<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>


    <script type="text/javaScript" language="javascript">

	    // AUIGrid 생성 후 반환 ID
	    var myGridID;
	    var gridValue;
    
        var option = {
                width : "1000px", // 창 가로 크기
                height : "600px" // 창 세로 크기
            };
    
    
    
        function fn_close(){
            window.close();
        }
        
        
        function createAUIGrid(){
		        // AUIGrid 칼럼 설정
		        var columnLayout = [ {
                            dataField : "custId",
                            headerText : "Customer",
                            width : 120
                        }, {
                            dataField : "name",
                            headerText : "Customer Name",
                            width : 120                            
                       }, {
                            dataField : "salesOrdNo",
                            headerText : "Sales Order",
                            width : 120
                        }, {
                            dataField : "hsDate",
                            headerText : "HS Date",
                            width : 120
                        }, {                        
		                    dataField : "no",
		                    headerText : "HS Order",
		                    width : 120
                        }, {
                            dataField : "codyId",
                            headerText : "Assign Cody",
                            width : 120		         
                        }, {
                            dataField : "stusCodeId",
                            headerText : "Cody Status",
                            width : 120
                        }, {
                            dataField : "month",
                            headerText : "Availability",
                            width : 120             
                        }, {
                            dataField : "month",
                            headerText : "Complete Cody",
                            width : 120
                        }, {
                            dataField : "brnchId",
                            headerText : "Branch",
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
            Common.ajax("GET", "/bs/selectHsManualList.do", $("#searchForm").serialize(), function(result) {
                
                console.log("성공.");
                console.log("data : " + result);
                AUIGrid.setGridData(myGridID, result);
            });     
        }
        
        

        //Start AUIGrid
        $(document).ready(function() {
                 $('#myBSMonth').val($.datepicker.formatDate('mm/yy', new Date()));
            
            
                // AUIGrid 그리드를 생성합니다.
		        createAUIGrid();
                AUIGrid.setSelectionMode(myGridID, "singleRow");


/*            $('#cmdBranchCode').change(function (){
                 var cmdBranchVal = $('#cmdBranchCode').val();
                 
                 if(cmdBranchVal != null && cmdBranchVal.length != 0  ){
                    doGetCombo('/bs/getCdUpMemList.do', $(this).val() , ''   , 'cmdCdManager' , 'S', '');
                 }else {
                    getSelectClear('#cmdCdManager');
                 }
                
            }); */

 /*           $('#cmdCdManager').change(function (){
                 alert("22222222222::::" + $('#cmdCdManager').val());
                doGetCombo('/bs/getCdList.do', $(this).val() , ''   , 'cmdcodyCode' , 'S', '');
            });
  */           
            
         $("#cmdBranchCode").change(function() {
            $("#cmdCdManager").find('option').each(function() {
                $(this).remove();
            });
             $("#cmdcodyCode").find('option').each(function() {
                $(this).remove();
            });
            
            if ($(this).val().trim() == "") {
                return;
            }       
            doGetCombo('/bs/getCdUpMemList.do', $(this).val() , ''   , 'cmdCdManager' , 'S', '');
        });    

                            

	         $("#cmdCdManager").change(function() {
	            $("#cmdcodyCode").find('option').each(function() {
	                $(this).remove();
	            });
	            if ($(this).val().trim() == "") {
	                return;
	            }       
	           doGetCombo('/bs/getCdList.do', $(this).val() , ''   , 'cmdcodyCode' , 'S', '');
	        });   
        
        
        
        });
    
    
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
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form action="#" method="post">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:100px" />
    <col style="width:*" />
    <col style="width:100px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Cody Branch</th>
    <td>
    <select id="cmdBranchCode" name="cmdBranchCode" class="w100p">
           <option value="">branchCode</option>
           <c:forEach var="list" items="${branchList }" varStatus="status">
           <option value="${list.codeId}">${list.codeName}</option>
           </c:forEach>
    </select>
    </td>
    <th scope="row">Cody Manager</th>
    <td>
        <select id="cmdCdManager" name="cmdCdManager" class="w100p">
    </td>
        <th scope="row">Cody</th>
    <td>
        <select id="cmdcodyCode" name="cmdcodyCode" class="w100p">
        <option value="">cody</option>
    </td>
</tr>
<tr>
    <th scope="row">HS Order</th>
    <td>
        <input id="txtHsOrderNo" name="txtHsOrderNo"  type="text" title="" placeholder="HS Order" class="w100p" />
    </td>
    <th scope="row">HS Period</th>
    <td>
        <input id="myBSMonth" name="myBSMonth" type="text" title="기준년월" placeholder="MM/YYYY" class="j_date2 w100p" readonly />
    </td>
    <th scope="row">Customer</th>
    <td>
        <input id="txtCustomer" name="txtCustomer"  type="text" title="" placeholder="Customer" class="w100p" />
    </td>
    
</tr>
<tr>
    <th scope="row">Sales Order</th>
    <td>
        <input id="txtSalesOrder" name="txtSalesOrder"  type="text" title="" placeholder="Sales Order" class="w100p" />
    </td>
    <th scope="row">Install Month</th>
    <td>
        <input id="myInstallMonth" name="myInstallMonth" type="text" title="기준년월" placeholder="MM/YYYY" class="j_date2 w100p" readonly />
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
    <li><p class="btn_grid"><a href="#" " onclick="javascript:fn_getBSListAjax();">Search</a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
그리드 영역
    <div id="grid_wrap" style="width: 100%; height: 334px; margin: 0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

<ul class="center_btns">
    <li><p class="btn_blue2"><a href="#">Cody Assign</a></p></li>
</ul>

</section><!-- content end -->
</form>