<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title><spring:message code="title.sample" /></title>
    <link type="text/css" rel="stylesheet" href="<c:url value='/resources/css/egovframework/sample.css'/>"/>
    
<!-- AUIGrid -->    
    <!-- AUIGrid 테마 CSS 파일입니다. 그리드 출력을 위해 꼭 삽입하십시오. -->
    <!-- 원하는 테마가 있다면, 다른 파일로 교체 하십시오. -->
    
    
    <link href="${pageContext.request.contextPath}/resources/AUIGrid/AUIGrid_style.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/multiple/multiple-select.css" />
    
    <script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery-2.2.4.min.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/common.js"></script>        <!-- 일반 공통 js -->
    <script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/gridCommon.js"></script>    <!-- AUIGrid 공통함수. 같이 추가해 보아요~ -->
    <script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/util.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery.serializejson.js"></script> <!-- Form to jsonObject -->
        
    <!-- AUIGrid 라이센스 파일입니다. 그리드 출력을 위해 꼭 삽입하십시오. -->
    <script type="text/javascript" src="${pageContext.request.contextPath}/resources/AUIGrid/AUIGridLicense.js"></script>
    
    <!-- 실제적인 AUIGrid 라이브러리입니다. 그리드 출력을 위해 꼭 삽입하십시오.--> 
    <script type="text/javascript" src="${pageContext.request.contextPath}/resources/AUIGrid/AUIGrid.js"></script>
    
    <script src="${pageContext.request.contextPath}/resources/multiple/multiple-select.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/combodraw.js"></script>
    
    
    
<!-- AUIGrid -->



<style type="text/css">

/* 커스텀 칼럼 스타일 정의 */
.my-column {
    text-align:right;
}

</style>
    
    <script type="text/javaScript" language="javascript">
    
 // AUIGrid 생성 후 반환 ID
    var myGridID;
    var filterGrid;
    var serviceGrid;
    var imgGrid;
    
 // AUIGrid 칼럼 설정
    var columnLayout = [ {dataField:"stkid"             ,headerText:"StockID"           ,width:120},
                         {dataField:"stkcode"           ,headerText:"StockCode"         ,width:120},
                         {dataField:"stkdesc"           ,headerText:"StockName"         ,width:120},
                         {dataField:"stkcategoryid"        ,headerText:"CategoryID"      ,width:120},
                         {dataField:"codename"        ,headerText:"CategoryName"      ,width:120},
                         {dataField:"stktypeid"            ,headerText:"TypeID"          ,width:120},
                         {dataField:"codename1"            ,headerText:"TypeName"          ,width:120},
                         {dataField:"name"      ,headerText:"StatusCodeName"    ,width:120},
                         {dataField:"issirim"             ,headerText:"IsSirim"           ,width:120},
                         {dataField:"isncv"               ,headerText:"IsNCV"             ,width:120},
                         {dataField:"qtypercarton"   ,headerText:"QuantityPerCarton" ,width:120},
                         {dataField:"netweight"           ,headerText:"NetWeight"         ,width:120},
                         {dataField:"grossweight"         ,headerText:"GrossWeight"       ,width:120},
                         {dataField:"measurementcbm"      ,headerText:"MeasurementCBM"    ,width:120},
                         {dataField:"stkgrade"          ,headerText:"StockGrade"        ,width:120
                         }];
    
    var filtercolumn = [ {dataField:"stockid"             ,headerText:"StockID"       ,width:120 , visible : false},
                         {dataField:"stockname"           ,headerText:"Description"   ,width:120},
                         {dataField:"typeid"              ,headerText:"Type"          ,width:120 , visible : false},
                         {dataField:"typenm"              ,headerText:"TypeName"      ,width:120},
                         {dataField:"period"              ,headerText:"Period"        ,width:120},
                         {dataField:"qty"                 ,headerText:"Qty"           ,width:120}];
    
    var servicecolumn = [{dataField:"packageid"           ,headerText:"PACKAGEID"     ,width:120 , visible : false},
                         {dataField:"packagename"         ,headerText:"Description"   ,width:120},
                         {dataField:"chargeamt"           ,headerText:"Qty"           ,width:120 }];
    
    
    var stockimgcolumn =[{dataField : "imgurl",        headerText : "",   prefix : "/resources", 
    	                  renderer : { type : "ImageRenderer", imgHeight : 24//, // 이미지 높이, 지정하지 않으면 rowHeight에 맞게 자동 조절되지만 빠른 렌더링을 위해 설정을 추천합니다.
									   //altField : "country" // alt(title) 속성에 삽입될 필드명, 툴팁으로 출력됨
									 }},
                         {dataField:"codenm"         ,headerText:"Angle"     ,width:120 },
                         {dataField : "undefined"    ,headerText:"",
                             renderer : {
                                 type : "ButtonRenderer",
                                 labelText : "Show Image",
                                 onclick : function(rowIndex, columnIndex, value, item) {
                                     //alert("( " + rowIndex + ", " + columnIndex + " ) " + item.imgurl + " 상세보기 클릭");
                                     $("#imgShow").html("<img src='/resources"+item.imgurl+"' width='250px' height='250px'>")
                                 }
                             }
                         },
                         {dataField:"angeid"         ,headerText:"angeid"    ,width:120 , visible : false},
                         {dataField:"scodeid"        ,headerText:"scodeid"   ,width:120 , visible : false},
                         {dataField:"stkid"          ,headerText:"stkid"     ,width:120 , visible : false},
                         {dataField:"imgid"          ,headerText:"imgid"     ,width:120 , visible : false},
                         {dataField:"udate"          ,headerText:"udate"     ,width:120 , visible : false},
                         {dataField:"uuser"          ,headerText:"uuser"     ,width:120, visible : false},
                         {dataField:"cdate"          ,headerText:"cdate"     ,width:120, visible : false},
                         {dataField:"cuser"          ,headerText:"cuser"     ,width:120 , visible : false}]
    
    var subgridpros = {
            // 페이지 설정
            usePaging : true,                
            pageRowCount : 10,                
            //fixedColumnCount : 1,
            //editable : true,                
            //enterKeyColumnBase : true,                
            //selectionMode : "multipleCells",                
            //useContextMenu : true,                
            //enableFilter : true,            
            //useGroupingPanel : true,
            //showStateColumn : true,
            //displayTreeOpen : true,
            noDataMessage : "출력할 데이터가 없습니다.",
           // groupingMessage : "여기에 칼럼을 드래그하면 그룹핑이 됩니다.",
            enableSorting : true
    };

    $(document).ready(function(){
        // AUIGrid 그리드를 생성합니다.
        createAUIGrid(columnLayout);        
        AUIGrid.removeAjaxLoader(myGridID);
        
        filterAUIGrid(filtercolumn);        
        AUIGrid.removeAjaxLoader(filterGrid);
        
        serviceAUIGrid(servicecolumn);        
        AUIGrid.removeAjaxLoader(serviceGrid);
        
        imgAUIGrid(stockimgcolumn);        
        AUIGrid.removeAjaxLoader(imgGrid);

    });
    $(function(){
    	$("#stock_info").click(function(){
            if($("#stock_info_div").css("display") == "none"){
                var selectedItems = AUIGrid.getSelectedItems(myGridID);
                for(i=0; i<selectedItems.length; i++) {
                    f_view("/stock/StockInfo.do?stkid="+selectedItems[i].item.stkid , "S");
                }
                $("#stock_info_div").show();
                $("#price_info_div").hide();
                $("#filter_info_div").hide();
                $("#service_info_div").hide();
                $("#stock_img_td").hide();
            }else{
                $("#price_info_div").hide();
                $("#filter_info_div").hide();
                $("#service_info_div").hide();
                $("#stock_img_td").hide();
            }           
         });
    	$("#price_info").click(function(){
            if($("#price_info_div").css("display") == "none"){
                var selectedItems = AUIGrid.getSelectedItems(myGridID);
                for(i=0; i<selectedItems.length; i++) {
                    f_view("/stock/PriceInfo.do?stkid="+selectedItems[i].item.stkid+"&typeid="+selectedItems[i].item.stktypeid, "P");
                }
                $("#price_info_div").show();
                $("#stock_info_div").hide();
                $("#filter_info_div").hide();
                $("#service_info_div").hide();
                $("#stock_img_td").hide();
            }else{
                $("#stock_info_div").hide();
                $("#filter_info_div").hide();
                $("#service_info_div").hide();
                $("#stock_img_td").hide();
            }
         });
        $("#filter_info").click(function(){
            if($("#filter_info_div").css("display") == "none"){
            	var selectedItems = AUIGrid.getSelectedItems(myGridID);
                for(i=0; i<selectedItems.length; i++) {
                    f_view("/stock/FilterInfo.do?stkid="+selectedItems[i].item.stkid+"&grid=filter", "F");
                }
                $("#filter_info_div").show();
                $("#price_info_div").hide();
                $("#stock_info_div").hide();
                $("#service_info_div").hide();
                $("#stock_img_td").hide();
            }else{
            	var selectedItems = AUIGrid.getSelectedItems(myGridID);
                for(i=0; i<selectedItems.length; i++) {
                    f_view("/stock/FilterInfo.do?stkid="+selectedItems[i].item.stkid+"&grid=filter", "F");
                }
                $("#stock_img_td").hide();
            	$("#price_info_div").hide();
                $("#stock_info_div").hide();
                $("#service_info_div").hide();
            }
         });
        $("#spare_info").click(function(){
            if($("#filter_info_div").css("display") == "none"){
                var selectedItems = AUIGrid.getSelectedItems(myGridID);
                for(i=0; i<selectedItems.length; i++) {
                    f_view("/stock/FilterInfo.do?stkid="+selectedItems[i].item.stkid+"&grid=spare", "F");
                }
                $("#filter_info_div").show();
                $("#price_info_div").hide();
                $("#stock_info_div").hide();
                $("#service_info_div").hide();
                $("#stock_img_td").hide();
            }else{
                var selectedItems = AUIGrid.getSelectedItems(myGridID);
                for(i=0; i<selectedItems.length; i++) {
                    f_view("/stock/FilterInfo.do?stkid="+selectedItems[i].item.stkid+"&grid=spare", "F");
                }
                $("#stock_img_td").hide();
                $("#price_info_div").hide();
                $("#stock_info_div").hide();
                $("#service_info_div").hide();
            }
         });
        $("#service_info").click(function(){
            if($("#service_info_div").css("display") == "none"){
                var selectedItems = AUIGrid.getSelectedItems(myGridID);
                for(i=0; i<selectedItems.length; i++) {
                    f_view("/stock/ServiceInfo.do?stkid="+selectedItems[i].item.stkid, "V");
                }
                $("#service_info_div").show();
                $("#filter_info_div").hide();
                $("#price_info_div").hide();
                $("#stock_info_div").hide();
                $("#stock_img_td").hide();
            }else{
            	$("#stock_img_td").hide();
                $("#filter_info_div").hide();
                $("#price_info_div").hide();
                $("#stock_info_div").hide();
            }
         });
        $("#stock_image").click(function(){
            if($("#stock_img_td").css("display") == "none"){
                var selectedItems = AUIGrid.getSelectedItems(myGridID);
                for(i=0; i<selectedItems.length; i++) {
                    f_view("/stock/StockImgList.do?stkid="+selectedItems[i].item.stkid, "I");
                }
                $("#stock_img_td").show();
                $("#service_info_div").hide();
                $("#filter_info_div").hide();
                $("#price_info_div").hide();
                $("#stock_info_div").hide();
            }else{
            	$("#service_info_div").hide();
                $("#filter_info_div").hide();
                $("#price_info_div").hide();
                $("#stock_info_div").hide();
            }
         });
    });
   
    // AUIGrid 를 생성합니다.
    function createAUIGrid(columnLayout) {
        
        // 그리드 속성 설정
        var gridPros = {
        		// 페이지 설정
        		usePaging : true,        		
        		pageRowCount : 30,        		
        		fixedColumnCount : 1,
                // 편집 가능 여부 (기본값 : false)
                editable : true,                
                // 엔터키가 다음 행이 아닌 다음 칼럼으로 이동할지 여부 (기본값 : false)
                enterKeyColumnBase : true,                
                // 셀 선택모드 (기본값: singleCell)
                selectionMode : "multipleCells",                
                // 컨텍스트 메뉴 사용 여부 (기본값 : false)
                useContextMenu : true,                
                // 필터 사용 여부 (기본값 : false)
                enableFilter : true,            
                // 그룹핑 패널 사용
                useGroupingPanel : true,                
                // 상태 칼럼 사용
                showStateColumn : true,                
                // 그룹핑 또는 트리로 만들었을 때 펼쳐지게 할지 여부 (기본값 : false)
                displayTreeOpen : true,                
                noDataMessage : "출력할 데이터가 없습니다.",                
                groupingMessage : "여기에 칼럼을 드래그하면 그룹핑이 됩니다.",                
                //selectionMode : "multipleCells",
                //rowIdField : "stkid",
                enableSorting : true
                
        };
        
        // 실제로 #grid_wrap 에 그리드 생성
        myGridID = AUIGrid.create("#grid_wrap", columnLayout, gridPros);
        
        //
        AUIGrid.bind(myGridID, "cellClick", function(event) {
        	var selectedItems = event.selectedItems;
        	f_view("/stock/StockInfo.do?stkid="+AUIGrid.getCellValue(myGridID , event.rowIndex , "stkid") , "S");
        	$("#subDiv").show();
        	if (AUIGrid.getCellValue(myGridID , event.rowIndex , "stktypeid") == "61"){
        		$("#filter_info").show();
                $("#spare_info").show();
        		$("#service_info").hide();
            }else{
            	$("#service_info").show();
        		$("#filter_info").hide();
                $("#spare_info").hide();
        	}
        	$("#stock_info_div").show();
        	$("#price_info_div").hide();
            $("#filter_info_div").hide();
            $("#service_info_div").hide();
            $("#stock_img_td").hide();
            $("#imgShow").html("");
        });
    }
    
    
 // AUIGrid 를 생성합니다.
    function filterAUIGrid(filtercolumn) {
        filterGrid = AUIGrid.create("#filter_info_div", filtercolumn, subgridpros);
    }
 
    function serviceAUIGrid(servicecolumn) {
        serviceGrid = AUIGrid.create("#service_info_div", servicecolumn, subgridpros);
    }
    
    function imgAUIGrid(stockimgcolumn) {
    	imgGrid = AUIGrid.create("#stock_img_div", stockimgcolumn, subgridpros);
    }

    
    function getSampleListAjax() {
        //var param1 = $('#listForm').serialize();
        //var param = $("#listForm").serializeJSON();
        //var param3 = $("#listForm").serializeArray();

        var param = $('#listForm').serialize();
        
        //var json_str = JSON.stringify(param); // Obejct(리터럴)을 json문법에 맞게 string 타입으로 변형
        //console.log(" ::: " + json_str)  
        
        //console.log(json_str);

        $.ajax({
            type : "POST",
            url : "/stock/StockList.do?"+param,
            //url : "/stock/StockList.do",
            //data : param,
            dataType : "json",
            contentType : "application/json;charset=UTF-8",
            success : function(data) {
            	var gridData = data;
            	
            	AUIGrid.setGridData(myGridID, gridData.data);
            },
            error: function(jqXHR, textStatus, errorThrown){
                alert("실패하였습니다.");
                
            },
            complete: function(){
            }
        });       
    }
    
    function f_view(url , v) {
    	f_clearForm();
        $.ajax({
            type : "POST",
            url : url,
            dataType : "json",
            contentType : "application/json;charset=UTF-8",
            success : function(_data) {
            	
            	var data = _data.data;
            	
            	f_info(data , v);
                
            },
            error: function(jqXHR, textStatus, errorThrown){
                alert("실패하였습니다.");
            }
        });       
    }
    
    function f_info(data , v){
    	if (v == 'S'){
	    	$("#txtStockType").text(data[0].typenm);         
	    	$("#txtStatus").text(data[0].statusname);        
	    	$("#txtStockCode").text(data[0].stockcode);      
	    	$("#txtUOM").text(data[0].uomname);              
	    	$("#txtStockName").text(data[0].stockname);      
	    	$("#txtCategory").text(data[0].categotynm);      
	    	$("#txtNetWeight").text(data[0].netweight);      
	    	$("#txtGrossWeight").text(data[0].grossweight);  
	    	$("#txtMeasurement").text(data[0].mcbm);
	    	
	    	if (data[0].isncv == 1){
	        	$("#cbNCV").prop("checked",true);
	        }
	        if (data[0].issirim == 1){
	        	$("#cbSirim").prop("checked",true);
	        }
	        $("#typeid").val(data[0].typeid);
    	}else if (v == 'P'){
    		$("#txtCost").text(data[0].pricecost);
    		$("#txtNormalPrice").text(data[0].amt);
    		$("#txtPV").text(data[0].pricepv);
    		$("#txtMonthlyRental").text(data[0].mrental);
    		$("#txtRentalDeposit").text(data[0].pricerpf);
    		$("#txtPenaltyCharge").text(data[0].penalty);
    		$("#txtTradeInPV").text(data[0].tradeinpv);
    	}else if(v == 'F'){
            AUIGrid.setGridData(filterGrid, data);
        }else if(v == 'V'){
            AUIGrid.setGridData(serviceGrid, data);
        }else if(v == 'I'){
            AUIGrid.setGridData(imgGrid, data);
        }
    }
    
    
    function searchClick(){
    	getSampleListAjax();
    }
    
    //doGetCombo('/common/selectCodeList.do', '11', '','cmbCategory', 'S' , 'f_multiCombo'); //Single COMBO => Choose One
    //doGetCombo('/common/selectCodeList.do', '11', '','cmbCategory', 'A' , 'f_multiCombo'); //Single COMBO => ALL
    //doGetCombo('/common/selectCodeList.do', '11', '','cmbCategory', 'M' , 'f_multiCombo'); //Multi COMBO
    // f_multiCombo 함수 호출이 되어야만 multi combo 화면이 안깨짐.
    doGetCombo('/common/selectCodeList.do', '11', '','cmbCategory', 'M' , 'f_multiCombo'); //청구처 리스트 조회
    doGetCombo('/common/selectCodeList.do', '15', '','cmbType', 'M' , 'f_multiCombo'); //청구처 리스트 조회
    
    function f_multiCombo(){
    	$(function() {
            $('#cmbCategory').change(function() {
                //console.log($(this).val());
            }).multipleSelect({
                selectAll: true, // 전체선택 
                width: '100%'
            });
            $('#cmbType').change(function() {
                //console.log($(this).val());
            }).multipleSelect({
                selectAll: true,
                width: '100%'
            });
            $('#cmbStatus').change(function() {
                //console.log($(this).val());
            }).multipleSelect({
                selectAll: true,
                width: '100%'
            });            
        });
    }
    
    function f_clearForm(){
    	$("#typeid").val("");
    	$("#txtStockType").text();         
        $("#txtStatus").text();        
        $("#txtStockCode").text();      
        $("#txtUOM").text();              
        $("#txtStockName").text();      
        $("#txtCategory").text();      
        $("#txtNetWeight").text();      
        $("#txtGrossWeight").text();  
        $("#txtMeasurement").text();
        $("#cbNCV").prop("checked",false);
        $("#cbSirim").prop("checked",false);
        $("#txtCost").text();
        $("#txtNormalPrice").text();
        $("#txtPV").text();
        $("#txtMonthlyRental").text();
        $("#txtRentalDeposit").text();
        $("#txtPenaltyCharge").text();
        $("#txtTradeInPV").text();
    }
    </script>
</head>

<body style="text-align:center; margin:0 auto; display:inline; padding-top:100px;">

        <div id="content_pop">
            <!-- 타이틀 -->
            <div id="title">
                <ul>
                    <li><img src="<c:url value='/resources/images/egovframework/example/title_dot.gif'/>" alt=""/><spring:message code="list.sample" /></li>
                </ul>
            </div>
            <form id="listForm" method="post" onsubmit="return false;">
<!--             <input type="hidden" name="selectedId" id="selectedId" value="111"/> -->
            <div class="container">
                 <table class="form-group">
                    <label>Category</label>
                      <select ID="cmbCategory" name="cmbCategory">
                      </select>
                       
                       <label>Type</label>
                       <select ID="cmbType" name="cmbType">
                       </select>
                     
                     <label>Status</label>
                     <select ID="cmbStatus" NAME="cmbStatus" Style="height: 24px; width: 100%;"  multiple="multiple">
                             <option Value="1"> Active</option>
                             <option Value="7"> Obsolete</option>
                             <option Value="8"> Inactive</option>
                      </select>
                      
<!--                       <label>sample</td> -->
<!--                      <select ID="cmbSample" NAME="cmbSample" placeholder="category" Style="height: 24px; width: 100%;"> -->
<!--                       </select> -->
                    <label>Stock Code : </label>
                    <input type=text name="stkCd" id="stkCd" value="">
                    
                    <label>Stock Name : </label>
                    <input type=text name="stkNm" id="stkNm" value="">
                    
                    </table>
                       
                    <a href="javascript:searchClick()" id="a-search">SEARCH</a>
            </div>
            </form>
            <!-- grid -->
            <div id="main">
                <div>
                    <!-- 에이유아이 그리드가 이곳에 생성됩니다. -->
                    <div id="grid_wrap" style="width:800px; height:250px; margin:0 auto;"></div>
                </div>
            </div>
            <div id="main">
                <div>
		            <div id="subDiv" style="display:none;width:800px; height:250px;">
		                <div id="stock_info">stock info</div> 
			            <div id="price_info">Price & Value Information</div>
			            <div id="filter_info">Filter Info</div> 
			            <div id="spare_info">Spare Part Info</div> 
			            <div id="service_info">Service Charge Info</div> 
			            <div id="stock_image">Stock Image</div>
			            
		                <div id="stock_info_div" style="width:800px; height:250px; margin:0 auto;display:none;">
		                    <table class="tableview">
		                     <tr>
		                         <td class="label" style="width: 12%; text-align: left;">Stock Type</td>
		                         <td style="width:22%" ID="txtStockType"></td>
		                         <td class="label" style="width: 12%; text-align: left;">Status</td>
		                         <td style="width:22%" ID="txtStatus"></td>
		                         <td colspan="2">
		                            <input type="checkbox" ID="cbSirim"/>Sirim Certificate&nbsp;&nbsp;
		                            <input type="checkbox" ID="cbNCV"/>NCV
		                         </td>
		                     </tr>
		                     <tr>
		                         <td class="label" style="width: 12%; text-align: left;">Stock Code</td>
		                         <td style="width:22%" ID="txtStockCode"></td>
		                         <td class="label" style="width: 12%; text-align: left;">UOM</td>
		                         <td colspan="3" ID="txtUOM"></td>
		                     </tr>
		                     <tr>
		                         <td class="label" style="width: 12%; text-align: left;">Stock Name</td>
		                         <td colspan="3" ID="txtStockName"></td>
		                         <td class="label" style="width: 12%; text-align: left;">Category</td>
		                         <td style="width:21%" ID="txtCategory"></td>
		                     </tr>
		                     <tr>
		                         <td class="label" style="width: 12%; text-align: left;">Net Weight (KG)</td>
		                         <td style="width:22%" ID="txtNetWeight"></td>
		                         <td class="label" style="width: 12%; text-align: left;">Gross Weight (KG)</td>
		                         <td style="width:21%" ID="txtGrossWeight"></td>
		
		                         <td class="label" style="width: 12%; text-align: left;">Measurement CBM</td>
		                         <td style="width:21%" ID="txtMeasurement"></td>
		                        </tr>
		                    </table>
		                </div>
			            <div id="price_info_div" style="width:800px; height:250px; margin:0 auto; display:none;">
					        <table class="tableview">
						        <tr>
							        <td class="label" style="width: 12%; text-align: left;">Cost</td>
							        <td style="width:22%" ID="txtCost"></td>
							        <td class="label" style="width: 12%; text-align: left;">Normal Price</td>
							        <td style="width:21%" ID="txtNormalPrice"></td>
							        <td class="label" style="width: 12%; text-align: left;">Point of Value (PV)</td>
							        <td style="width:21%" ID="txtPV"></td>
						        </tr>
						        <tr>
							        <td class="label" style="width: 12%; text-align: left;">Monthly Rental</td>
							        <td style="width:22%" ID="txtMonthlyRental"></td>
							        <td class="label" style="width: 12%; text-align: left;">Rental Deposit</td>
							        <td style="width:21%" ID="txtRentalDeposit"></td>
							        <td class="label" style="width: 12%; text-align: left;">Penalty Charges</td>
							        <td style="width:21%" ID="txtPenaltyCharge"></td>
						        </tr>
						        <tr>
							        <td class="label" style="width: 12%; text-align: left;">Trade In (PV) Value</td>
							        <td colspan="5" ID="txtTradeInPV"></td>
						        </tr>
					        </table>
					    </div>
					    <div id="filter_info_div" style="width:800px; height:250px; margin:0 auto;display:none;"></div>
					    <div id="service_info_div" style="width:800px; height:250px; margin:0 auto;display:none;"></div>
					    <div id="stock_img_td" style="width:800px; height:250px; margin:0 auto;display:none;">
					       <table class="tableview">
                                <tr>
                                    <td style="width: 70%; text-align: left;"><div id="stock_img_div" style="width:800px; height:250px; margin:0 auto;"></div></td>
                                    <td style="width:1%">&nbspl;</td>
                                    <td style="width: 29%;" id="imgShow"></td>
                                </tr>
                            </table>					    
					    </div>
				</div>
			</div></div>
        </div>
</body>

</html>
