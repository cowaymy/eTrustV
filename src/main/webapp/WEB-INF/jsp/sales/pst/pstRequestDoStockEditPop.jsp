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
<script type="text/javascript" src="js/jquery.min.js"></script>
<script type="text/javascript" src="js/jquery-ui.min.js"></script>
<script type="text/javascript" src="js/jquery.ui.core.min.js"></script>
<script type="text/javascript" src="js/jquery.ui.datepicker.min.js"></script>
<script type="text/javascript" src="js/common.js"></script>

<script type="text/javaScript" language="javascript">

    //AUIGrid 생성 후 반환 ID
    var myGridID;
    
//  var result = ${pstStockList};

    $(document).ready(function(){

        //AUIGrid 그리드를 생성합니다.
        myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout);
        
//        AUIGrid.setSelectionMode(myGridID, "singleRow");

        fn_getPstStockListAjax();

        //AUIGrid.setGridData(myGridID, result);
    });
    
    // AUIGrid 칼럼 설정
    var columnLayout = [ {
            dataField : "c2",
            headerText : "Stock Description",
            editable : false
        }, {
            dataField : "pstItmReqQty",
            headerText : "Request</br>Quantity",
            width : 105,
            editable : false
        }, {
            dataField : "pstItmBalQty",
            headerText : "Balance Quantity",
            width : 130,
            editable : false
        }, {
            dataField : "pstItmCanQty2",
            headerText : "Cancel</br>Quantity",
            width : 100
        }, {
            dataField : "pstItmCanQty",
            headerText : "Cancel</br>Quantity",
            width : 100,
            visible : false
        }, {
            dataField : "pstItmPrc",
            headerText : "Item Price",
            width : 120,
            editable : false
        }, {
            dataField : "pstStockRem",
            headerText : "Remark",
            width : 170
        }];
    
    //리스트 조회.
    function fn_getPstStockListAjax() {
        Common.ajax("GET", "/sales/pst/getPstStockJsonDetailPop", $("#searchForm").serialize(), function(result) {
            AUIGrid.setGridData(myGridID, result);
        }
        );
    }
 
    function fn_goPstInfo(){
        location.href = "/sales/pst/getPstRequestDOEditPop.do?isPop=true&pstSalesOrdId="+searchForm.pstSalesOrdId.value;
    }
    
    function fn_updateStockList() {
        var pstRequestDOForm = {
            dataSet     : GridCommon.getEditData(myGridID),
            pstSalesMVO : {
                pstSalesOrdId : searchForm.pstSalesOrdId.value,
                pstRefNo      : searchForm.pstRefNo.value
            }
        };
      
        Common.ajax("POST", "/sales/pst/updateStockList.do", pstRequestDOForm, function(result) {
            
            alert("PST info successfully updated");
            
            fn_getPstStockListAjax();
          //resetUpdatedItems(); // 초기화
            
            console.log("PST info successfully updated.");
            console.log("data : " + result);
            
        },  function(jqXHR, textStatus, errorThrown) {
            try {
                console.log("status : " + jqXHR.status);
                console.log("code : " + jqXHR.responseJSON.code);
                console.log("message : " + jqXHR.responseJSON.message);
                console.log("detailMessage : " + jqXHR.responseJSON.detailMessage);
          }
          catch (e) {
              console.log(e);
              alert("Saving data prepration failed.");
          }

          alert("Fail : " + jqXHR.responseJSON.message);          
      });
    }
    
    
    function fn_close(){
        window.close();
    }
</script>
</head>
<body>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>PST Request Info Edit</h1>
 
<ul class="right_opt">
<!--    <li><p class="btn_blue2"><a href="#">COPY</a></p></li>
    <li><p class="btn_blue2"><a href="#">EDIT</a></p></li>
    <li><p class="btn_blue2"><a href="#">NEW</a></p></li>-->
    <li><p class="btn_blue2"><a href="#"  onclick="javascript:fn_close()">CLOSE</a></p></li>
</ul>
 
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<ul class="tap_type1">
    <li><a href="#" onclick="javascript:fn_goPstInfo()">PST info</a></li>
    <li><a href="#">PST Mail Address</a></li>
    <li><a href="#">PST Delivery Address</a></li>
    <li><a href="#">PST Mail Contact</a></li>
    <li><a href="#">PST Delivery Contact</a></li>
    <li><a href="#" class="on">PST Stock List</a></li>
</ul>
<h2>Request Item List</h2>

<form name="searchForm" id="searchForm">
    <input type="hidden" id="pstSalesOrdId" name="pstSalesOrdId" value="${pstSalesOrdId}">
    <input type="hidden" id="pstRefNo" name="pstRefNo" value="${pstRefNo}">
</form>

<!-- search_result start -->
<div class="search_result">
    <!-- grid_wrap start -->
    <div id="grid_wrap" style="width:100%; height:380px; margin:0 auto;"></div>
    <!-- grid_wrap end -->
</div>
<!-- search_result end -->

<ul class="center_btns">
    <li><p class="btn_blue2"><a href="#" onClick="javascript:fn_updateStockList();">UPDATE STOCK</a></p></li>
</ul>

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->
</body>
</html>