<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="utf-8"/>
<meta content="width=1280px,user-scalable=yes,target-densitydpi=device-dpi" name="viewport"/>
<title>eTrust system</title>
<link rel="stylesheet" type="text/css" href="css/master.css" />
<link rel="stylesheet" type="text/css" href="css/common.css" />
<style type="text/css">

.left_style { text-align: left; }

</style>
<script type="text/javaScript" language="javascript">

    //AUIGrid 생성 후 반환 ID
    var myGridID;
    
    var gridValue;
    
    var option = {
            width : "1000px", // 창 가로 크기
            height : "600px" // 창 세로 크기
    };
    
    $(document).ready(function(){
    
        // AUIGrid 그리드를 생성합니다.
        createAUIGrid();
        
        AUIGrid.setSelectionMode(myGridID, "singleRow");
        
        // 셀 더블클릭 이벤트 바인딩
        AUIGrid.bind(myGridID, "cellDoubleClick", function(event) {
//            alert(event.rowIndex+ " - double clicked!! : " + event.value + " - rowValue : " + AUIGrid.getCellValue(myGridID, event.rowIndex, "pstSalesOrdId"));
            Common.popupWin("searchForm", "/sales/pst/getPstRequestDODetailPop.do?isPop=true&pstSalesOrdId=" + AUIGrid.getCellValue(myGridID, event.rowIndex, "pstSalesOrdId"), option);
        });
        
     // 셀 더블클릭 이벤트 바인딩
        AUIGrid.bind(myGridID, "cellClick", function(event) {
            gridValue =  AUIGrid.getCellValue(myGridID, event.rowIndex, "pstSalesOrdId");
        });
    
        //fn_selectPstRequestDOListAjax();
    
    
    });
 
    function createAUIGrid() {
    	// AUIGrid 칼럼 설정
    	
        // 데이터 형태는 다음과 같은 형태임,
        //[{"id":"#Cust0","date":"2014-09-03","name":"Han","country":"USA","product":"Apple","color":"Red","price":746400}, { .....} ];
        var columnLayout = [ {
                dataField : "pstRefNo",
                headerText : "PSO No",
                width : 140,
                editable : false,
                style: 'left_style'
            }, {
                dataField : "dealerName",
                headerText : "Dealer Name",
                editable : false,
                style: 'left_style'
            }, {
                dataField : "pstCustPo",
                headerText : "Customer PO",
                width : 170,
                editable : false,
                style: 'left_style'
            }, {
                dataField : "c1",
                headerText : "PSO Date",
                width : 160,
                editable : false,
                style: 'left_style'
            }, {
                dataField : "code1",
                headerText : "PSO Status",
                width : 170,
                editable : false,
                style: 'left_style'
            }, {
                dataField : "pstSalesOrdId",
                visible : false
            }];

     // 그리드 속성 설정
        var gridPros = {
            
            // 페이징 사용       
            usePaging : true,
            
            // 한 화면에 출력되는 행 개수 20(기본값:20)
            pageRowCount : 20,
            
            editable : true,
            
            fixedColumnCount : 1,
            
            showStateColumn : true, 
            
            displayTreeOpen : true,
            
            selectionMode : "multipleCells",
            
            headerHeight : 30,
            
            // 그룹핑 패널 사용
            useGroupingPanel : true,
            
            // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
            skipReadonlyColumns : true,
            
            // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
            wrapSelectionMove : true,
            
            // 줄번호 칼럼 렌더러 출력
            showRowNumColumn : false,
            
            
        
            groupingMessage : "Here groupping"
        };
        
        //myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout, gridPros);
        myGridID = AUIGrid.create("#grid_wrap", columnLayout, gridPros);
    }
    
    
    // 리스트 조회.
    function fn_selectPstRequestDOListAjax() {        
        Common.ajax("GET", "/sales/pst/selectPstRequestDOJsonList", $("#searchForm").serialize(), function(result) {
            AUIGrid.setGridData(myGridID, result);
        }
        );
    }
    
    function fn_goPstInfoEdit(){
    	Common.popupWin("searchForm", "/sales/pst/getPstRequestDOEditPop.do?isPop=true&pstSalesOrdId=" + gridValue, option);
    }
</script>
</head>
<body>

<div id="wrap"><!-- wrap start -->

	<header id="header"><!-- header start -->
		<ul class="left_opt">
		    <li>Neo(Mega Deal): <span>2394</span></li> 
		    <li>Sales(Key In): <span>9304</span></li> 
		    <li>Net Qty: <span>310</span></li>
		    <li>Outright : <span>138</span></li>
		    <li>Installment: <span>4254</span></li>
		    <li>Rental: <span>4702</span></li>
		    <li>Total: <span>45080</span></li>
		</ul>
		<ul class="right_opt">
		    <li>Login as <span>KRHQ9001-HQ</span></li>
		    <li><a href="#" class="logout">Logout</a></li>
		    <li><a href="#"><img src="image/top_btn_home.gif" alt="Home" /></a></li>
		    <li><a href="#"><img src="image/top_btn_set.gif" alt="Setting" /></a></li>
		</ul>
	</header><!-- header end -->
    <hr />
        
	<section id="container"><!-- container start -->
	
	   <aside class="lnb_wrap"><!-- lnb_wrap start -->
	
		<header class="lnb_header"><!-- lnb_header start -->
		<form action="#" method="post">
		<h1><a href="#"><img src="image/logo.gif" alt="eTrust system" /></a></h1>
		<p class="search">
		<input type="text" title="검색어 입력" />
		<input type="image" src="image/icon_lnb_search.gif" alt="검색" />
		</p>
		
		</form>
		</header><!-- lnb_header end -->
	
		<section class="lnb_con"><!-- lnb_con start -->
			<p class="click_add_on_solo on"><a href="#">All menu</a></p>
			<ul class="inb_menu">
			    <li class="on">
			    <a href="#">menu 1depth</a>
			
			    <ul>
			        <li class="on">
			        <a href="#">menu 2depth</a>
			
			        <ul>
			            <li class="on">
			            <a href="#">menu 3depth</a>
			            </li>
			            <li>
			            <a href="#">menu 3depth</a>
			            </li>
			            <li>
			            <a href="#">menu 3depth</a>
			            </li>
			            <li>
			            <a href="#">menu 3depth</a>
			            </li>
			            <li>
			            <a href="#">menu 3depth</a>
			            </li>
			            <li>
			            <a href="#">menu 3depth</a>
			            </li>
			        </ul>
			
			        </li>
			        <li>
			        <a href="#">menu 2depth</a>
			        </li>
			        <li>
			        <a href="#">menu 2depth</a>
			        </li>
			        <li>
			        <a href="#">menu 2depth</a>
			        </li>
			        <li>
			        <a href="#">menu 2depth</a>
			        </li>
			        <li>
			        <a href="#">menu 2depth</a>
			        </li>
			    </ul>
			
			    </li>
			    <li>
			    <a href="#">menu 1depth</a>
			    </li>
			    <li>
			    <a href="#">menu 1depth</a>
			    </li>
			    <li>
			    <a href="#">menu 1depth</a>
			    </li>
			    <li>
			    <a href="#">menu 1depth</a>
			    </li>
			    <li>
			    <a href="#">menu 1depth</a>
			    </li>
			</ul>
				<p class="click_add_on_solo"><a href="#"><span></span>My menu</a></p>
				<ul class="inb_menu">
				    <li>
				    <a href="#">My menu 1depth</a>
				    </li>
				    <li>
				    <a href="#">My menu 1depth</a>
				    </li>
				    <li>
				    <a href="#">My menu 1depth</a>
				    </li>
				    <li>
				    <a href="#">My menu 1depth</a>
				    </li>
				    <li>
				    <a href="#">My menu 1depth</a>
				    </li>
				    <li>
				    <a href="#">My menu 1depth</a>
				    </li>
				</ul>
			</section><!-- lnb_con end -->
	
	</aside><!-- lnb_wrap end -->
	
	<section id="content"><!-- content start -->
		<ul class="path">
		    <li><img src="image/path_home.gif" alt="Home" /></li>
		    <li>Sales</li>
		    <li>Order list</li>
		</ul>
	
	<aside class="title_line"><!-- title_line start -->
	<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
	<h2>PST Request Do List</h2>
	<ul class="right_opt">
	    <li><p class="btn_blue"><a href="#" onclick="javascript:fn_goPstInfoEdit()">EDIT</a></p></li>
	    <li><p class="btn_blue"><a href="#">NEW</a></p></li>
	</ul>
	</aside><!-- title_line end -->
	
	<section class="search_table"><!-- search_table start -->
		<form id="searchForm" name="searchForm" action="#" method="post">
		
		<table class="type1"><!-- table start -->
		<caption>search table</caption>
		<colgroup>
		    <col style="width:130px" />
		    <col style="width:*" />
		    <col style="width:160px" />
		    <col style="width:*" />
		    <col style="width:165px" />
		    <col style="width:220px" />
		</colgroup>
		<tbody>
		<tr>
		    <th scope="row">PSO No</th>
		    <td><input type="text" title="PSO No" id="pstSalesOrdId" name="pstSalesOrdId" placeholder="PSO Number" class="w100p" /></td>
		    <th scope="row">PSO Status</th>
		    <td>
		    <dl class="fake_select w100p">
		        <dt><input type="text" readonly="readonly" /></dt>
		        <dd>
		        <ul>
		            <li><label><input type="checkbox" value="1" id="pstStusId1" name="pstStusId1"/><span>Active</span></label></li>
		            <li><label><input type="checkbox" value="4" id="pstStusId4" name="pstStusId4" /><span>Completed</span></label></li>
		            <li><label><input type="checkbox" value="10" id="pstStusId10" name="pstStusId10" /><span>Cancel</span></label></li>
		        </ul>
		        </dd>
		    </dl>
		    </td>
		    <th scope="row">Create Date</th>
		    <td>
		
		    <div class="date_set"><!-- date_set start -->
		    <p><input type="text" id="createStDate" name="createStDate" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
		    <span>To</span>
		    <p><input type="text" id="createEnDate" name="createEnDate" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
		    </div><!-- date_set end -->
		
		    </td>
		</tr>
		<tr>
		    <th scope="row">Dealer ID</th>
		    <td><input type="text" id="pstDealerId" name="pstDealerId" title="Dealer ID" placeholder="Dealer ID" class="w100p" /></td>
		    <th scope="row">Dealer Name</th>
		    <td><input type="text" id="dealerName" name="dealerName" title="Dealer Name" placeholder="Dealer Name" class="w100p" /></td>
		    <th scope="row">NRIC/Company No</th>
		    <td><input type="text" id="dealerNric" name="dealerNric" title="NRIC/Company No" placeholder="NRIC/Company No" class="w100p" /></td>
		</tr>
		<tr>
		    <th scope="row">Customer PO</th>
		    <td><input type="text" id="pstCustPo" name="pstCustPo" title="Customer PO" placeholder="Customer PO" class="w100p" /></td>
		    <th scope="row">Person In Charge</th>
		    <td><input type="text" id="userName" name="userName" title="Person In Charge" placeholder="Person In Charge" class="w100p" /></td>
		    <th scope="row"></th>
		    <td></td>
		</tr>
		</tbody>
		</table><!-- table end -->
		
		<ul class="right_btns">
		    <li><p class="btn_gray"><a href="#" onclick="javascript:fn_selectPstRequestDOListAjax()"><span class="search"></span>Search</a></p></li>
		</ul>
		
		</form>
	</section><!-- search_table end -->
	
	<section class="search_result"><!-- search_result start -->
	
	<aside class="link_btns_wrap"><!-- link_btns_wrap start -->
	<p class="show_btn"><a href="#"><img src="image/btn_link.gif" alt="link show" /></a></p>
	<dl class="link_list">
	    <dt>Link</dt>
	    <dd>
	    <ul class="btns">
	        <li><p class="link_btn"><a href="#">Do Request(Warehouse)</a></p></li>
	        <li><p class="link_btn"><a href="#">View Report</a></p></li>
	        <li><p class="link_btn type2"><a href="#">View Dealer</a></p></li>
	    </ul>
<!--
 	    <ul class="btns">
	        <li><p class="link_btn type2"><a href="#">menu8</a></p></li>
	    </ul>
 -->
	    <p class="hide_btn"><a href="#"><img src="image/btn_link_close.gif" alt="hide" /></a></p>
	    </dd>
	</dl>
	</aside><!-- link_btns_wrap end -->
	<!-- 안씀
	<ul class="right_btns">
	    <li><p class="btn_grid"><a href="#"><span class="search"></span>EXCEL UP</a></p></li>
	    <li><p class="btn_grid"><a href="#"><span class="search"></span>EXCEL DW</a></p></li>
	    <li><p class="btn_grid"><a href="#"><span class="search"></span>DEL</a></p></li>
	    <li><p class="btn_grid"><a href="#"><span class="search"></span>INS</a></p></li>
	    <li><p class="btn_grid"><a href="#"><span class="search"></span>ADD</a></p></li>
	</ul>
	 -->
	<article class="grid_wrap"><!-- grid_wrap start -->

		<div id="grid_wrap" style="width:100%; height:480px; margin:0 auto;"></div>

	</article><!-- grid_wrap end -->
	
	<aside class="bottom_msg_box"><!-- bottom_msg_box start -->
	<p>Information Message Area</p>
	</aside><!-- bottom_msg_box end -->
	
	</section><!-- search_result end -->
	
	</section><!-- content end -->
	        
	</section><!-- container end -->
	<hr />

</div><!-- wrap end -->
</body>
</html>