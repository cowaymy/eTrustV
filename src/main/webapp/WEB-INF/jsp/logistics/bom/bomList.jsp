<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp" %>

<style type="text/css">

/* 커스텀 칼럼 스타일 정의 */
.aui-grid-user-custom-left {
    text-align:left;
}

/* 커스컴 disable 스타일*/
.mycustom-disable-color {
    color : #cccccc;
}

/* 그리드 오버 시 행 선택자 만들기 */
.aui-grid-body-panel table tr:hover {
    background:#D9E5FF;
    color:#000;
}
.aui-grid-main-panel .aui-grid-body-panel table tr td:hover {
    background:#D9E5FF;
    color:#000;
}

</style>
<link rel="stylesheet" href="http://code.jquery.com/ui/1.11.1/themes/smoothness/jquery-ui.css">
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery.blockUI.min.js"></script>
<script type="text/javaScript" language="javascript">

    // AUIGrid 생성 후 반환 ID
    var myGridID;
    var materialGrid;
    var filterGrid;
    var serviceGrid;
    
    var selectedItem; 
    
    // AUIGrid 칼럼 설정             // formatString : "mm/dd/yyyy",    dataType:"numeric", formatString : "#,##0"
     var columnLayout = [
								{dataField:"bom",headerText:"Material Cdoe",width:"15%",visible:true},
								{dataField:"altrtivBom",headerText:"",width:"15%",visible:false},
								{dataField:"plant",headerText:"Material Code Name",width:"15%",visible:true},
								{dataField:"matrlNo",headerText:"",width:"15%",visible:false},
								{dataField:"bomUse",headerText:"",width:"15%",visible:false},
								{dataField:"bomItmNodeNo",headerText:"",width:"15%",visible:false},
								{dataField:"bomCtgry",headerText:"",width:"15%",visible:false},
								{dataField:"intnlCntr",headerText:"",width:"15%",visible:false},
								{dataField:"itmCtgry",headerText:"",width:"15%",visible:false},
								{dataField:"bomItmNo",headerText:"",width:"15%",visible:false},
								{dataField:"sortString",headerText:"",width:"15%",visible:false},
								{dataField:"bomCompnt",headerText:"Component",width:"15%",visible:true},
								{dataField:"stkDesc",headerText:"Component Name",width:"15%",visible:true},
								{dataField:"compntQty",headerText:"Qty",width:"15%",visible:true},
								{dataField:"compntUnitOfMeasure",headerText:"",width:"15%",visible:false},
								{dataField:"validFromDt",headerText:"Valid from",width:"15%",visible:true},
								{dataField:"validToDt",headerText:"Valid to",width:"15%",visible:true},
								{dataField:"chngNo",headerText:"",width:"15%",visible:false},
								{dataField:"delIndict",headerText:"",width:"15%",visible:false},
								{dataField:"dtRcordCrtOn",headerText:"",width:"15%",visible:false},
								{dataField:"userWhoCrtRcord",headerText:"",width:"15%",visible:false},
								{dataField:"chngOn",headerText:"",width:"15%",visible:false},
								{dataField:"namePersonWhoChgObj ",headerText:"",width:"15%",visible:false}
                         ];
    
    
    var gridoptions = {showStateColumn : false , editable : false, pageRowCount : 30, usePaging : true, useGroupingPanel : false , fixedColumnCount:2};
    

    $(document).ready(function(){
        // masterGrid 그리드를 생성합니다.
        myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout,"", gridoptions);
        
        //doGetComboAddr('/common/selectAddrSelCodeList.do', 'country' , '' ,'this.value','srchCntry', 'S', '');
        //doGetComboAddr('/common/selectAddrSelCodeList.do', 'country' , '' ,'this.value','srchCntry', 'S', '');
        doGetComboCDC('/logistics/bom/selectCdcList', '' , '' , '','cdcCmb', 'S', '');
        AUIGrid.bind(myGridID, "cellClick", function( event ) 
        {   
        });

        // 셀 더블클릭 이벤트 바인딩
        AUIGrid.bind(myGridID, "cellDoubleClick", function(event) 
        {
        });
        
        AUIGrid.bind(myGridID, "ready", function(event) {
        });
    });

    $(function(){
        $("#search").click(function(){
            searchAjax();
        });
        $("#view").click(function(){
            div="V";
            $("#detailHead").text("Courier Information Details");
            selectedItem = AUIGrid.getSelectedIndex(myGridID);
            if (selectedItem[0] > -1){
                fn_openDetail(div,selectedItem[0]);
                $("#editWindow").show();
            }else{
            Common.alert('Choice Data please..');
            }
        });
        $("#update").click(function(){
            div="U";
            $("#detailHead").text("Courier Information Update");
            selectedItem = AUIGrid.getSelectedIndex(myGridID);
            if (selectedItem[0] > -1){
                fn_openDetail(div,selectedItem[0]);
                $("#editWindow").show();
            }else{
            Common.alert('Choice Data please..');
            }
       
        });
        $("#insert").click(function(){
                div="N";
                $("#detailHead").text("Courier Information New");
                fn_setVisiable(div);
                $("#editWindow").show();
        });
        $("#cancelPopbtn").click(function(){
            $("#editWindow").hide();
        });
        $("#updatePopbtn").click(function(){
            //$("#editWindow").hide();
               div="U";
               saveAjax(div);
               $("#editWindow").hide();
              
        });
        $("#savePopbtn").click(function(){
            //$("#editWindow").hide();
               div="N";
               saveAjax(div);
               $("#editWindow").hide();
              
        });
        $(".numberAmt").keyup(function(e) {
            regex = /[^.0-9]/gi;
            v = $(this).val();
            if (regex.test(v)) {
                var nn = v.replace(regex, '');
                $(this).val(v.replace(regex, ''));
                $(this).focus();
                return;
            }
        });
       $("#curcntyid").change(function(){
           doDefCombo('', '' ,'curstateid', 'S', ''); 
           doDefCombo('', '' ,'curareaid', 'S', '');
           doDefCombo('', '' ,'curpostcod', 'S', '');   
         }); 
       $("#curstateid").change(function(){
           doDefCombo('', '' ,'curareaid', 'S', '');
           doDefCombo('', '' ,'curpostcod', 'S', '');   
         }); 
       $("#curareaid").change(function(){
           doDefCombo('', '' ,'curpostcod', 'S', '');   
         }); 
       
       $("#srchCntry").change(function(){
           doDefCombo('', '' ,'srchState', 'S', ''); 
           doDefCombo('', '' ,'srchArea', 'S', '');
           doDefCombo('', '' ,'srchPstCd', 'S', '');   
         }); 
       $("#srchState").change(function(){
           doDefCombo('', '' ,'srchArea', 'S', '');
           doDefCombo('', '' ,'srchPstCd', 'S', '');   
         }); 
       $("#srchArea").change(function(){
           doDefCombo('', '' ,'srchPstCd', 'S', '');   
         }); 
    });
    
    
/*  모달  */    
    function f_showModal(){
        $.blockUI.defaults.css = {textAlign:'center'}
        $('div.SalesWorkDiv').block({
                message:"<img src='/resources/images/common/CowayLeftLogo.png' alt='Coway Logo' style='max-height: 46px;width:160px' /><div class='preloader'><i id='iloader'>.</i><i id='iloader'>.</i><i id='iloader'>.</i></div>",
                centerY: false,
                centerX: true,
                css: { top: '300px', border: 'none'} 
        });
    }
    function hideModal(){
        $('div.SalesWorkDiv').unblock();
        
    }
    /* function Start*/
   function doGetComboCDC(url, groupCd ,codevalue ,  selCode, obj , type, callbackFn){
    	
    	$.ajax({
    		  type : "GET",
    	        url : url,
    	        data :{ groupCode : groupCd , codevalue : codevalue},
    	        dataType : "json",
    	        contentType : "application/json;charset=UTF-8",
    	        success : function(data) {
    	        	console.log(rData);
    	           var rData = data;
    	           //doDefCombo(rData, '', 'cdcCmb' , 'S',  '');
    	           doDefCombo(rData, selCode, obj , type,  callbackFn);
    	        },
    	        error: function(jqXHR, textStatus, errorThrown){
    	            alert("Draw ComboBox['"+obj+"'] is failed. \n\n Please try again.");
    	        },
    	        complete: function(){
    	        }
    	});
    } 
    
    
   function searchAjax() {
        f_showModal();
        var url = "/logistics/bom/selectBomList.do";
        var param = $('#searchForm').serializeJSON();
        Common.ajax("POST" , url , param , function(data){
            console.log(data.data);
            AUIGrid.setGridData(myGridID, data.data);
            hideModal();
        });
    }
    
   function saveAjax(div) {
        var url;
        var key;
        var val= $("#detailForm").serializeJSON();
        selectedItem = AUIGrid.getSelectedIndex(myGridID);
       if(div=="U"){
           url="/logistics/courier/motifyCourier.do";
       }else if(div=="N"){
           url="/logistics/courier/insertCourier.do";
       }
       Common.ajax("POST",url,val,function(result){
           Common.alert(result.msg);
           $("#search").trigger("click");
           if(div=="U"){
                 $("#view").click();
          }
       });
   } 
   
    
    function fn_openDetail(div,idxId){
        var id =AUIGrid.getCellValue(myGridID ,idxId, 'courierid');
        Common.ajaxSync("GET", "/logistics/courier/selectCourierDetail",{"courierid":id} ,
                function(data){
                var setVal=data.result;
                if(div=="V"){
                    fn_setValuePop(setVal);
                    fn_setVisiable(div);
                }else if(div=="U"){
                    fn_setValuePop(setVal);
                    fn_setVisiable(div);
                }else if(div=="N"){
                }
        });
    }
    function fn_setValuePop(setVal){
        $("#curcode").val(setVal[0].curierCode);
        $("#curname").val(setVal[0].curierName);
        $("#curregno").val(setVal[0].curierRegNo);
        doGetComboAddr('/common/selectAddrSelCodeList.do', 'country' , '' , setVal[0].curierCntyId,'curcntyid', 'S', ''); 
        getAddrRelay( 'curstateid' , setVal[0].curierCntyId , 'state' , setVal[0].curierStateId);
        getAddrRelay( 'curareaid' , setVal[0].curierStateId , 'area' , setVal[0].curierAreaId);
        getAddrRelay( 'curpostcod' , setVal[0].curierAreaId , 'post' ,  setVal[0].curierPostCodeId);
        
        $("#curcntcno1").val(setVal[0].curierCntcNo1);
        $("#curcntcno2").val(setVal[0].curierCntcNo2);
        $("#curfaxno").val(setVal[0].curierFaxNo);
        $("#curemail").val(setVal[0].curierEmail);
        $("#curadd1").val(setVal[0].curierAdd1);
        $("#curadd2").val(setVal[0].curierAdd2);
        $("#curadd3").val(setVal[0].curierAdd3);  
            
    }
    
    function fn_setVisiable(div){
        if(div=="V"){
              $("#curcode").prop('readonly', true);
              $("#curname").prop('readonly', true);
              $("#curregno").prop('readonly', true);
              $("#curcntyid").prop('disabled', true);
              $("#curstateid").prop('disabled', true);
              $("#curareaid").prop('disabled', true);
              $("#curpostcod").prop('disabled', true);
              $("#curcntcno1").prop('readonly', true);
              $("#curcntcno2").prop('readonly', true);
              $("#curfaxno").prop('readonly', true);
              $("#curemail").prop('readonly', true);
              $("#curadd1").prop('readonly', true);
              $("#curadd2").prop('readonly', true);
              $("#curadd3").prop('readonly', true);
              $("#savePopbtn").hide();
              $("#updatePopbtn").hide();
        }else if(div=="U"){
            $("#curcode").prop('readonly', true);
            $("#curname").prop('readonly', false);
            $("#curregno").prop('readonly', false);
            $("#curcntyid").prop('disabled', false);
            $("#curstateid").prop('disabled', false);
            $("#curareaid").prop('disabled', false);
            $("#curpostcod").prop('disabled', false);
            $("#curcntcno1").prop('readonly', false);
            $("#curcntcno2").prop('readonly', false);
            $("#curfaxno").prop('readonly', false);
            $("#curemail").prop('readonly', false);
            $("#curadd1").prop('readonly', false);
            $("#curadd2").prop('readonly', false);
            $("#curadd3").prop('readonly', false);
            
            $("#updatePopbtn").show();
            $("#savePopbtn").hide();
        }else if(div=="N"){
            $("#curcode").val("Auto-Generate");            
            $("#curname").val("");
            $("#curregno").val("");
            //$("#curcntyid").val("");
            //$("#curstateid").val("");
            //$("#curareaid").val("");
            //$("#curpostcod").val("");
            $("#curcntcno1").val("");
            $("#curcntcno2").val("");
            $("#curfaxno").val("");
            $("#curemail").val("");
            $("#curadd1").val("");
            $("#curadd2").val("");
            $("#curadd3").val(""); 
            
            $("#curname").prop('readonly', false);
            $("#curregno").prop('readonly', false);
            $("#curcntyid").prop('disabled', false);
            $("#curstateid").prop('disabled', false);
            $("#curareaid").prop('disabled', false);
            $("#curpostcod").prop('disabled', false);
            $("#curcntcno1").prop('readonly', false);
            $("#curcntcno2").prop('readonly', false);
            $("#curfaxno").prop('readonly', false);
            $("#curemail").prop('readonly', false);
            $("#curadd1").prop('readonly', false);
            $("#curadd2").prop('readonly', false);
            $("#curadd3").prop('readonly', false);
            
            $("#savePopbtn").show();
            $("#updatePopbtn").hide();
            
            combReset();
        }
    }
    
  function combReset(){
            doGetComboAddr('/common/selectAddrSelCodeList.do', 'country' ,'', 'this.value','curcntyid', 'S', ''); 
            doDefCombo('', '' ,'curstateid', 'S', ''); 
            doDefCombo('', '' ,'curareaid', 'S', '');
            doDefCombo('', '' ,'curpostcod', 'S', '');   
      
  }
  
 
</script>
<div id="SalesWorkDiv" class="SalesWorkDiv" style="width: 100%; height: 960px; position: static; zoom: 1;">
	<section id="content">
		<!-- content start -->
		<ul class="path">
			<li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif"
				alt="Home" /></li>
			<li>View</li>
			<li>BOM List</li>
		</ul>
         <!-- title_line start -->
		<aside class="title_line">
			<p class="fav">
				<a href="#" class="click_add_on">My menu</a>
			</p>
			<h2>View - BOM List</h2>
			<ul class="right_btns">
				<li><p class="btn_blue">
						<a id="search"><span class="search"></span>
						<spring:message code='sys.btn.search' /></a>
					</p></li>
				<li><p class="btn_blue">
						<a id="clear"><span class="clear"></span>
						<spring:message code='sys.btn.clear' /></a>
					</p></li>
			</ul>
		</aside>
		<!-- title_line end -->


			<!-- search_table start -->
		<section class="search_table">
			<form id="searchForm" name="searchForm">
				<input type="hidden" id="sUrl" name="sUrl">
				<table class="type1">
					<!-- table start -->
					<caption>table</caption>
					<colgroup>
						<col style="width: 150px" />
						<col style="width: *" />
						<col style="width: 160px" />
						<col style="width: *" />
						<col style="width: 160px" />
						<col style="width: *" />
					</colgroup>
					<tbody>
						<tr>
							<th scope="row">Material Code</th>
							<td>
								<div class="date_set w100p">
									<!-- date_set start -->
									<p>
										<select class="w100p">
											<option value="">11</option>
											<option value="">22</option>
											<option value="">33</option>
										</select>
									</p>
									<span>~</span>
									<p>
										<select class="w100p">
											<option value="">11</option>
											<option value="">22</option>
											<option value="">33</option>
										</select>
									</p>
								</div>
								<!-- date_set end -->
							</td>
							<th scope="row">CDC</th>
							<td><select class="w100p" id="cdcCmb" name="cdcCmb">
							</td>
							<th scope="row">Valid From Date</th>
							<td><div class="date_set">
									<!-- date_set start -->
									<p>
										<input type="text" title="Create start Date"
											placeholder="DD/MM/YYYY" class="j_date" />
									</p>
								</div></td>
						</tr>
					</tbody>
				</table>
				<!-- table end -->
			</form>
		</section>
		<!-- search_table end -->
		<aside class="link_btns_wrap">
			<!-- link_btns_wrap start -->
			<p class="show_btn">
				<a href="#"><img
					src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif"
					alt="link show" /></a>
			</p>
			<dl class="link_list">
				<dt>Link</dt>
				<dd>
					<ul class="btns">
						<li><p class="link_btn">
								<a href="#">menu1</a>
							</p></li>
						<li><p class="link_btn">
								<a href="#">menu2</a>
							</p></li>
						<li><p class="link_btn">
								<a href="#">menu3</a>
							</p></li>
						<li><p class="link_btn">
								<a href="#">menu4</a>
							</p></li>
						<li><p class="link_btn">
								<a href="#">Search Payment</a>
							</p></li>
						<li><p class="link_btn">
								<a href="#">menu6</a>
							</p></li>
						<li><p class="link_btn">
								<a href="#">menu7</a>
							</p></li>
						<li><p class="link_btn">
								<a href="#">menu8</a>
							</p></li>
					</ul>
					<ul class="btns">
						<li><p class="link_btn type2">
								<a href="#">menu1</a>
							</p></li>
						<li><p class="link_btn type2">
								<a href="#">Search Payment</a>
							</p></li>
						<li><p class="link_btn type2">
								<a href="#">menu3</a>
							</p></li>
						<li><p class="link_btn type2">
								<a href="#">menu4</a>
							</p></li>
						<li><p class="link_btn type2">
								<a href="#">Search Payment</a>
							</p></li>
						<li><p class="link_btn type2">
								<a href="#">menu6</a>
							</p></li>
						<li><p class="link_btn type2">
								<a href="#">menu7</a>
							</p></li>
						<li><p class="link_btn type2">
								<a href="#">menu8</a>
							</p></li>
					</ul>
					<p class="hide_btn">
						<a href="#"><img
							src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif"
							alt="hide" /></a>
					</p>
				</dd>
			</dl>
		</aside>
		<section class="search_result">
			<!-- search_result start -->

			<ul class="right_btns">

				<%-- <li><p class="btn_grid"><a href="#"><spring:message code='sys.btn.excel.up' /></a></p></li>
    <li><p class="btn_grid"><a href="#"><spring:message code='sys.btn.excel.dw' /></a></p></li>
    <li><p class="btn_grid"><a id="#"><spring:message code='sys.btn.del' /></a></p></li>
    <li><p class="btn_grid"><a href="#"><spring:message code='sys.btn.ins' /></a></p></li> --%>
				<li><p class="btn_grid">
						<a id="view"><spring:message code='sys.btn.view' /></a>
					</p></li>
				<li><p class="btn_grid">
						<a id="update"><spring:message code='sys.btn.update' /></a>
					</p></li>
				<li><p class="btn_grid">
						<a id="insert"><spring:message code='sys.btn.add' /></a>
					</p></li>
			</ul>

			<article class="grid_wrap">
				<!-- grid_wrap start -->
				<div id="grid_wrap"></div>
			</article>
			    <!--<section id="subDiv" style="display:none;" class="tap_wrap"> tap_wrap start -->
			    <section id="subDiv"class="tap_wrap"><!-- tap_wrap start -->
        
            <ul class="tap_type1">
                <li id="stock_info"><a href="#"> Stock info </a></li>
                <li id="price_info"><a href="#"> Price & Value Information</a></li>
                <li id="filter_info"><a href="#"> Filter Info</a></li>
                <li id="spare_info"><a href="#"> Spare Part Info</a></li>
                <li id="service_info"><a href="#"> Service Charge Info</a></li>
                <li id="stock_image"><a href="#"> Stock Image</a></li>
            </ul>
            <article class="tap_area" id="stock_info_div" style="display:none;">
                <aside class="title_line"><!-- title_line start -->
                <h3>Stock Information</h3>
                <ul class="left_opt">
                    <li><p class="btn_blue"><a id="stock_info_edit">EDIT</a></p></li>
                </ul>
                </aside>
                <form id="stockInfo" name="stockInfo" method="post">
                <table class="type1">
                    <caption>search table</caption>
                    <colgroup>
                        <col style="width:150px" />
                        <col style="width:*" />
                        <col style="width:160px" />
                        <col style="width:*" />
                        <col style="width:160px" />
                        <col style="width:*" />
                    </colgroup>
                    <tbody>
                    <tr>
                        <th scope="row">Stock Type</th>
                        <td ID="txtStockType"></td>
                        <th scope="row">Status</th>
                        <td ID="txtStatus"></td>
                        <td colspan="2">
                            <label><input type="checkbox" id="cbSirim"/><span>Sirim Certificate</span></label>
                            <label><input type="checkbox" id="cbNCV" /><span>NCV</span></label>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Stock Code</th>
                        <td ID="txtStockCode"></td>
                        <th scope="row">UOM</th>
                        <td colspan="3" id="txtUOM"></td>
                    </tr>
                    <tr>
                        <th scope="row">Stock Name</th>
                        <td colspan="3" id="txtStockName"></td>
                        <th scope="row">Category</th>
                        <td ID="txtCategory"></td>
                    </tr>
                    <tr>
                        <th scope="row">Net Weight (KG)</th>
                        <td ID="txtNetWeight"></td>
                        <th scope="row">Gross Weight (KG)</th>
                        <td ID="txtGrossWeight"></td>

                        <th scope="row">Measurement CBM</th>
                        <td ID="txtMeasurement"></td>
                    </tr>
                    </tbody>
                </table>
                </form>
            </article>

            <article class="tap_area" id="price_info_div" style="display:none;">
                <aside class="title_line"><!-- title_line start -->
                <h3>Price & Value Information</h3>
                <ul class="left_opt">
                    <li><p class="btn_blue"><a id="price_info_edit">EDIT</a></p></li>
                </ul>
                </aside>
                <form id='priceForm' name='priceForm' method='post'>
                <input type="hidden" name="priceTypeid" id="priceTypeid" value=""/>
                <table class="type1">
                    <caption>search table</caption>
                    <colgroup>
                        <col style="width:150px" />
                        <col style="width:*" />
                        <col style="width:160px" />
                        <col style="width:*" />
                        <col style="width:160px" />
                        <col style="width:*" />
                    </colgroup>
                    <tbody>
                    <tr>
                        <th scope="row">Cost</th>
                        <td ID="txtCost"></td>
                        <th scope="row">Normal Price</th>
                        <td ID="txtNormalPrice"></td>
                        <th scope="row">Point of Value (PV)</th>
                        <td ID="txtPV"></td>
                    </tr>
                    <tr>
                        <th scope="row">Monthly Rental</th>
                        <td ID="txtMonthlyRental"></td>
                        <th scope="row">Rental Deposit</th>
                        <td ID="txtRentalDeposit"></td>
                        <th scope="row">Penalty Charges</th>
                        <td ID="txtPenaltyCharge"></td>
                    </tr>
                    <tr>
                        <th scope="row">Trade In (PV) Value</th>
                        <td colspan="5" ID="txtTradeInPV"></td>
                    </tr>
                    </tbody>
                </table>
                </form>
            </article>
            
            <article class="tap_area" id="filter_info_div" style="display:none;">
                <aside class="title_line"><!-- title_line start -->
                    <h3 id="filterTab">Stock's Filter List</h3>
                    <ul class="left_opt">
                    <li><p class="btn_blue"><a id="filter_info_edit">EDIT</a></p></li>
                    </ul>
                </aside>
                <div id="filter_grid" style="width:100%;">
                </div>                
            </article>
            <article class="tap_area" id="spare_info_div" style="display:none;">
                <aside class="title_line"><!-- title_line start -->
                    <h3>Stock's Spare Part List</h3>
                    <ul class="left_opt">
                    <li><p class="btn_blue"><a id="spare_info_edit">EDIT</a></p></li>
                    </ul>
                </aside>
                <div id="spare_grid" style="width:100%;"></div>
            </article>
            <article class="tap_area" id="service_info_div" style="display:none;">
                <aside class="title_line"><!-- title_line start -->
                <h3>Service Charge Information List</h3>
                <ul class="left_opt">
                    <li><p class="btn_blue"><a id="service_info_edit">EDIT</a></p></li>
                </ul>
                </aside>
                <div id="service_grid" style="width:100%;"></div>
            </article>            
            <article class="tap_area" id="stock_img_td" style="display:none;">
                <table class="type1">
                    <caption>search table</caption>
                    <colgroup>
                        <col style="width:69%" />
                        <col style="width:1%" />
                        <col style="width:30%" />
                    </colgroup>
                    <tbody>
                    <tr>
                        <td  style="text-align: left;">
                            <div id="stock_img_div" style="width:100%;"></div></td>
                        <td >&nbsp;</td>
                        <td id="imgShow"></td>
                    </tr>
                </table>                        
            </article>
        </section><!--  tab -->
			<!-- grid_wrap end -->
		</section>
	</section>
</div>
