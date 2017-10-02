<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">

    //AUIGrid 생성 후 반환 ID
    var posGridID;
    
	$(document).ready(function() {
		  
		createAUIGrid();
		
		  doGetCombo("/common/selectCodeList.do", "143", '', 'cmbPosTypeId', 'S', ''); 
		  doGetCombo("/common/selectCodeList.do", "140", '', 'cmbSalesTypeId', 'S', '');
		  
		// AUIGrid 그리드를 생성합니다.
        
       
        AUIGrid.setSelectionMode(posGridID, "singleRow");
		  
        
        $("#_search").click(function() {
		
        	fn_getPosListAjax();
		});
        
        // 셀 더블클릭 이벤트 바인딩
        AUIGrid.bind(posGridID, "cellDoubleClick", function(event){
            
            $("#_posNo").val(event.item.posNo);
            Common.popupDiv("/sales/pos/selectPosViewDetail.do", $("#detailForm").serializeJSON(), null , true , '_editDiv');
            
        });
        
	});
	
	function createAUIGrid(){
		
		var posColumnLayout =  [ 
                                {dataField : "posNo", headerText : "POS Ref No.", width : '10%'}, 
                                {dataField : "posDt", headerText : "Sales Date", width : '10%'},
                                {dataField : "codeName", headerText : "POS Type", width : '10%'},
                                {dataField : "codeName1", headerText : "Sales Type", width : '10%'},
                                {dataField : "taxInvcRefNo", headerText : "Invoice No.", width : '10%'}, 
                                {dataField : "name", headerText : "Customer Name", width : '20%'},
                                {dataField : "whLocCode", headerText : "Warehouse", width : '10%'},
                                {dataField : "posTotAmt", headerText : "Total Amount", width : '10%'},
                                {dataField : "userName", headerText : "Sales Agent", width : '10%'},
                                {dataField : "posId", visible : false}
                               ];
		
		//그리드 속성 설정
        var gridPros = {
                
                usePaging           : true,         //페이징 사용
                pageRowCount        : 20,           //한 화면에 출력되는 행 개수 20(기본값:20)            
                editable            : false,            
                fixedColumnCount    : 1,            
                showStateColumn     : true,             
                displayTreeOpen     : false,            
                selectionMode       : "singleRow",  //"multipleCells",            
                headerHeight        : 30,       
                useGroupingPanel    : false,        //그룹핑 패널 사용
                skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
                wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
                showRowNumColumn    : true,         //줄번호 칼럼 렌더러 출력    
                noDataMessage       : "No order found.",
                groupingMessage     : "Here groupping"
        };
		
        posGridID = GridCommon.createAUIGrid("#pos_grid_wrap", posColumnLayout,'', gridPros);  // address list
	}
    
  function fn_getPosListAjax(){
	
	  Common.ajax("GET", "/sales/pos/selectPosJsonList", $("#searchForm").serialize(), function(result) {
		
		  AUIGrid.setGridData(posGridID, result);
	  });
	  
  }
  
  function fn_posTypeChangeFunc(codeId) {
	
	  if(codeId == 1343){ // Filter
		  
		  // 창고 select box 활성화
		  $("#cmbWhId").attr({"disabled" : false , "class" : "w100p"});
		  doGetComboWh("/sales/pos/selectWhList.do", '', '', 'cmbWhId', 'S', '');		  
		  
	  }else if(codeId == 1344){ // Item Bank & Others
		  // 창고 select box 비활성화
		  $("#cmbWhId option").remove();
		  $("#cmbWhId optgroup").remove();
		  $("#cmbWhId").attr({"disabled" : "disabled" , "class" : "disabled w100p"});
	  }else{ // Choose One
		  $("#cmbWhId option").remove();
          $("#cmbWhId optgroup").remove();
          $("#cmbWhId").attr({"disabled" : "disabled" , "class" : "disabled w100p"});
	  }
  }
  
  //def Combo(select Box OptGrouping)
  function doGetComboWh(url, groupCd , selCode, obj , type, callbackFn){
    
    $.ajax({
        type : "GET",
        url : url,
        data : { groupCode : groupCd},
        dataType : "json",
        contentType : "application/json;charset=UTF-8",
        success : function(data) {
           var rData = data;
           Common.showLoader(); 
           fn_otpGrouping(rData, obj)
        },
        error: function(jqXHR, textStatus, errorThrown){
            alert("Draw ComboBox['"+obj+"'] is failed. \n\n Please try again.");
        },
        complete: function(){
        	Common.removeLoader();
        }
    }); 
 } ;

 function fn_otpGrouping(data, obj){
	 
	 var targetObj = document.getElementById(obj);
	 
	 for(var i=targetObj.length-1; i>=0; i--) {
	        targetObj.remove( i );
	 }
	 
	 obj= '#'+obj;
	 
	 // grouping
	 var count = 0;
	 $.each(data, function(index, value){
		 
		 if(index == 0){
			$("<option />", {value: "", text: 'Choose One'}).appendTo(obj);
		 }
		 
		 if(index > 0 && index != data.length){
			 if(data[index].description1 != data[index -1].description1){
				 $(obj).append('</optgroup>');
				 count = 0;
	         }
		 }
		 
		 if(data[index].descId == null  && count == 0){
			 $(obj).append('<optgroup label="">');
			 count++;
		 }
		 if(data[index].descId == 42 && count == 0){
             $(obj).append('<optgroup label="Cody Branch">');
             count++;
         }
		 if(data[index].descId == 1160  && count == 0){
             $(obj).append('<optgroup label="Dealer Branch">');
             count++;
         }
		 if(data[index].descId == 43 && count == 0){
             $(obj).append('<optgroup label="Dream Service Center">');
             count++;
         }
		 //
		 if(data[index].descId == 46 && count == 0){
             $(obj).append('<optgroup label="Head Quaters">');
             count++;
         }
		 $('<option />', {value : data[index].whLocId, text:data[index].codeId+'-'+data[index].codeName}).appendTo(obj); // WH_LOC_ID
		 
		 
		 if(index == data.length){
			 $(obj).append('</optgroup>');
		 }
	 });
	 //optgroup CSS
	 $("optgroup").attr("class" , "optgroup_text");
	 
 }
</script>

<div id="wrap"><!-- wrap start -->
<!-- Detail Form -->
<form id="detailForm" method="get">
    <input type="hidden" id="_posNo" name="posNo"> 
</form>
<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>Sales</li>
    <li>POS</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>POS Listing</h2>
<ul class="right_btns">
    <li><p class="btn_blue"><a href="#" id="_search"><span class="search"></span>Search</a></p></li>
    <li><p class="btn_blue"><a href="#"><span class="clear"></span>Clear</a></p></li>
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form  id="searchForm">
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:170px" />
    <col style="width:*" />
    <col style="width:160px" />
    <col style="width:*" />
    <col style="width:170px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">POS Type</th>
    <td>
    <select class="w100p" id="cmbPosTypeId" onchange="javascript : fn_posTypeChangeFunc(this.value)" name="posModuleTypeId"></select>  
    </td>
    <th scope="row">Sales Type</th>
    <td>
    <select class="w100p" id="cmbSalesTypeId" name="posTypeId"></select>
    </td>
    <th scope="row">Sales Agent</th>
    <td>
    <input type="text" title="" placeholder="Sales Agent (Username)" class="w100p" name="userName"/>
    </td>
</tr>
<tr>
    <th scope="row">POS Ref No.</th>
    <td>
    <input type="text" title="" placeholder="POS Ref No." class="w100p"  name="posNo"/>
    </td>
    <th scope="row">Sales Date</th>
    <td>
    <div class="date_set w100p"><!-- date_set start -->
    <p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date"  name="sDate"/></p>
    <span>To</span>
    <p><input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" name="eDate" /></p>
    </div><!-- date_set end -->
    </td>
    <th scope="row">Member Code</th>
    <td>
    <input type="text" title="" placeholder="Member Code" class="w100p" name="memId" />
    </td>
</tr>
<tr>
    <th scope="row">Warehouse</th>
    <td>
    <select class="disabled w100p" disabled="disabled" id="cmbWhId" name="posWhId"></select>
    </td>
    <th scope="row">Customer Name</th>
    <td colspan="3">
    <input type="text" title="" placeholder="Customer Name" class="w100p" name="posCustName" />
    </td>
</tr>
</tbody>
</table><!-- table end -->
 <aside class="link_btns_wrap"><!-- link_btns_wrap start -->
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
</aside><!-- link_btns_wrap end -->

</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->
<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="pos_grid_wrap" style="width:100%; height:480px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- content end -->

</div><!-- wrap end -->