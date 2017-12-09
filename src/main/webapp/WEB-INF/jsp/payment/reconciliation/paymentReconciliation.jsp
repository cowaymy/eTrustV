<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<style type="text/css">
.my-custom-up {
    text-align:left;
}

/* 커스컴 disable 스타일*/
.mycustom-disable-color div{
    color : #cccccc;
}
</style>
<script type="text/javaScript">
//AUIGrid 그리드 객체
var masterListGridID;
var maintenanceGridID;
var selectedGridValue;
var gridPros = {
        // 상태 칼럼 사용
        showStateColumn : false
};

var keyValueList = [{"code":"105", "value":"CASH"}, {"code":"106", "value":"CHEQUE"}, {"code":"108", "value":"ONLINE"}];

$(document).ready(function(){
	
    doGetComboSepa('/common/selectBranchCodeList.do', '1' , ' - '  ,'' , 'branchId' , 'S', ''); //key-in Branch 생성
    doGetCombo('/sales/customer/selectAccBank.do', '', '', 'accountId', 'S', '')//selCodeAccBankId(Issue Bank)
	
	masterListGridID = GridCommon.createAUIGrid("master_grid_wrap", masterColumnLayout, null, gridPros);
	
    //Grid 셀 클릭시 이벤트
    AUIGrid.bind(masterListGridID, "cellClick", function( event ){
        selectedGridValue = event.rowIndex;
    });
    
});

// AUIGrid 칼럼 설정
var masterColumnLayout = [ 
	{
		dataField : "fDepReconRefNo",
		headerText : "Transaction No.",
		editable : false
	},{
        dataField : "fDepostPayDt",
        headerText : "Ref Date",
        editable : false
    },{
        dataField : "code",
        headerText : "Branch",
        editable : false
    },
    {
        dataField : "accCode",
        headerText : "Account",
        editable : false
    }, 
    {
        dataField : "code1",
        headerText : "Status",
        editable : false
    }, {
        dataField : "remark",
        headerText : "Remark",
        editable : false,
        style : "my-custom-up"
    }, {
        dataField : "fDepReconCrtDt",
        headerText : "Created",
        editable : false
    }, {
        dataField : "userName",
        headerText : "Creator",
        editable : false
    },{
        dataField : "fDepReconUpdDt",
        headerText : "Updated",
        editable : false
    },{
        dataField : "username1",
        headerText : "Updator",
        editable : false
    },{
        dataField : "fDepReconId",
        headerText : "",
        visible : false
    }];

var maintenancePopLayout = [ 
	{
	    dataField : "fDepItmDepostDt",
	    headerText : "Deposit Date",
	    dataType : "date",
        formatString : "dd/mm/yyyy",
        styleFunction : cellStyleFunction,
        editRenderer : {
          type : "CalendarRenderer",
          showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 출력 여부
          onlyCalendar : false, // 사용자 입력 불가, 즉 달력으로만 날짜입력 (기본값 : true)
          showExtraDays : true, // 지난 달, 다음 달 여분의 날짜(days) 출력
          validator : function(oldValue, newValue, rowItem) { // 에디팅 유효성 검사
        	  
        	  if(rowItem.fDepItmIsMtch == "0"){
        		  var date, isValid = true;
                  if(isNaN(Number(newValue)) ) { //20160201 형태 또는 그냥 1, 2 로 입력한 경우는 허락함.
                      if(isNaN(Date.parse(newValue))) { // 그냥 막 입력한 경우 인지 조사. 즉, JS 가 Date 로 파싱할 수 있는 형식인지 조사
                          isValid = false;
                      } else {
                          isValid = true;
                      }
                  }
                  // 리턴값은 Object 이며 validate 의 값이 true 라면 패스, false 라면 message 를 띄움
                  return { "validate" : isValid, "message"  : "" };
        	  }
              
        }

        }
	    
	}, {
	    dataField : "fDepItmModeId",
	    headerText : "Deposit Mode",
	    editable : false, // 그리드의 에디팅 사용 안함( 템플릿에서 만든 Select 로 에디팅 처리 하기 위함 )
        renderer : { // HTML 템플릿 렌더러 사용
            type : "TemplateRenderer"
        },
        labelFunction : function (rowIndex, columnIndex, value, headerText, item ) { // HTML 템플릿 작성
            if(!value)  return "";
            var code, text;
            var template = '<div class="my_div">';
            
            if(value == "None") {
                template += '';
            } else {
            	
            	var disableYN = "";
            	if(item.fDepItmIsMtch == "1"){
            		disableYN = "disabled";
            	}else{
            		disableYN = "";
            	}
                
                template += '<select style="width:100px;" onchange="javascript:mySelectChangeHandler(' + rowIndex + ', this.value, event);" ' + disableYN + '>';
                
                for(var i=0, len=keyValueList.length; i<len; i++) {
                    code =  keyValueList[i]["code"];
                    text = keyValueList[i]["value"];
                    if(code == value) { 
                        template += '<option value="' + code + '" selected="selected">' + text + '</option>';
                    } else {
                        template += '<option value="' + code + '">' + text + '</option>';
                    }
                }
                template += '</select>';
            }
            template += '</div>';
            return template; // HTML 템플릿 반환..그대로 innerHTML 속성값으로 처리됨
        }

	}, {
	    dataField : "fDepItmSlipNo",
	    headerText : "Deposit Slip No",
	    styleFunction : cellStyleFunction
	}, {
	    dataField : "fDepItmRem",
	    headerText : "Deposit Remark",
	    style : "my-custom-up",
	    styleFunction : cellStyleFunction
	}, {
	    dataField : "fDepItmAmt",
	    headerText : "Deposit Amount",
	    editable : false
	},{
	    dataField : "",
	    headerText : "Update",
	    renderer : {
            type : "ButtonRenderer",
            labelText : "Update",
            onclick : function(rowIndex, columnIndex, value, item) {
                if(item.fDepItmIsMtch == "0"){
                	
                    fn_updateDepositItem(item.fDepItmId, item.fDepItmModeId, item.fDepItmRem, item.fDepItmDepostDt, item.fDepItmSlipNo);
                }
            }
        }
	},{
	    dataField : "",
	    headerText : "Exclude",
	    renderer : {
            type : "ButtonRenderer",
            labelText : "Exclude",
            onclick : function(rowIndex, columnIndex, value, item) {
            	
            	if(item.fDepItmIsMtch == "0"){
            		
            		fn_saveExcludeDepositItem(item.fDepItmId, item.fDepostId, item.fDepItmRem);
                }
            }
        }
	}, {
        dataField : "fDepItmId",
        headerText : "fDepItmId",
        visible : false
    }, {
        dataField : "fDepostId",
        headerText : "fDepostId",
        visible : false
    }];

    function searchList(){
    	Common.ajax("GET","/payment/selectReconciliationMasterList.do", $("#searchForm").serialize(), function(result){
    		AUIGrid.setGridData(masterListGridID, result);
    	});
    }
    
    function fn_depositMaintenancePop(){
    	
    	var selectedItem = AUIGrid.getSelectedIndex(masterListGridID);
    	
    	if (selectedItem[0] > -1){
    		var reconId = AUIGrid.getCellValue(masterListGridID, selectedGridValue, "fDepReconId");
    		
    		Common.ajax("GET","/payment/selectLoadReconciliation.do", {"reconId" : reconId}, function(result){
    			
    			$('#maintenance_popup_wrap').show();
    			AUIGrid.destroy(maintenanceGridID);// 그리드 삭제
    			maintenanceGridID = GridCommon.createAUIGrid("maintenance_grid_wrap", maintenancePopLayout, null, gridPros);
    			AUIGrid.setGridData(maintenanceGridID, result.data.depositList);
    			
    			// 에디팅 시작 이벤트 바인딩
    		    AUIGrid.bind(maintenanceGridID, "cellEditBegin", function(event) {
    		        // 셀이 Anna 인 경우
    		        if(event.item.fDepItmIsMtch == "1"){
    		            return false;
    		        }
    		    });
    			
    			$('#maintenanceTransNo').val(result.data.depositView.fDepReconRefNo);
    			$('#maintenanceRefDate').val(result.data.depositView.fDepostPayDt);
    			$('#maintenanceStatus').val(result.data.depositView.code1);
    			$('#maintenanceBranch').val(result.data.depositView.code);
    			$('#maintenanceBank').val(result.data.depositView.accDesc);
    			$('#maintenanceCreUser').val(result.data.depositView.userName);
    			$('#maintenanceCreDate').val(result.data.depositView.fDepReconCrtDt);
    			
            });
    		
    	}else{
    		Common.alert('No Reconciliation No. selected. ');
    	}
    }
    
    function fn_updateDepositItem(fDepItmId, fDepItmModeId, remark, fDepItmDepostDt, fDepItmSlipNo){
    	
    	Common.ajax("GET","/payment/updDepositItem.do", 
    			{"fDepItmId" : fDepItmId, "fDepItmModeId" : fDepItmModeId, "remark":remark,"fDepItmDepostDt":fDepItmDepostDt,"fDepItmSlipNo":fDepItmSlipNo}, function(result){
    			fn_depositMaintenancePop();
    			Common.alert(result.message);
    		   
    	});
    }
    
    function fn_saveExcludeDepositItem(fDepItmId, fDepostId, remark){
    	
    	if(remark != undefined){
    		
    		Common.confirm('Are you sure you want to exclude this transaction?',function (){
                
                Common.ajax("GET","/payment/saveExcludeDepositItem.do", 
                        {"fDepItmId" : fDepItmId, "fDepostId" : fDepostId, "remark":remark}, function(result){
                        fn_depositMaintenancePop();
                        Common.alert(result.message);
                       
                });
            });
    		
    	}else{
    		Common.alert("* Deposit Remark cannot be empty.");
    	}
    }
    
    function fn_hideViewPop(val){
        $(val).hide();
        //AUIGrid.clearGridData(statementdetailPopGridID);
        //AUIGrid.clearGridData(journalEntryPopGridID);
    }
    
    function cellStyleFunction( rowIndex, columnIndex, value, headerText, item, dataField) {
    	if(item.fDepItmIsMtch == "1")
            return "mycustom-disable-color";
        
        return null;
    }
    
    // 셀렉트 변경 핸들러
    function mySelectChangeHandler(rowIndex, selectedValue, event) {
        
        // 그리드에 실제 업데이트 적용 시킴
        AUIGrid.updateRow(maintenanceGridID, {
            "fDepItmModeId" : selectedValue
        }, rowIndex);
    }

    
</script>

<section id="content"><!-- content start -->
	<ul class="path">
	    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
	    <li>Payment</li>
	    <li>Payment Reconciliation</li>
	</ul>
	<aside class="title_line"><!-- title_line start -->
		<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
		<h2>Reconciliation Search</h2>
		<ul class="right_opt">
		    <li><p class="btn_blue"><a href="javascript:searchList();"><span class="search"></span>Search</a></p></li>
		    <li><p class="btn_blue"><a href="#"><span class="clear"></span>Clear</a></p></li>
		</ul>
	</aside><!-- title_line end -->
	<section class="search_table"><!-- search_table start -->
		<form action="#" method="post" id="searchForm">
			<table class="type1"><!-- table start -->
				<caption>table</caption>
				<colgroup>
				    <col style="width:170px" />
				    <col style="width:*" />
				    <col style="width:230px" />
				    <col style="width:*" />
				</colgroup>
				<tbody>
					<tr>
					    <th scope="row">Transaction No.</th>
					    <td><input type="text" title="" placeholder="Transaction No." class="w100p" id="transNo" name="transNo" /></td>
					    <th scope="row">Bank Account</th>
					    <td>
						    <select class="w100p" id="accountId" name="accountId">
						    </select>
					    </td>
					</tr>
					<tr>
					    <th scope="row">Branch Code</th>
					    <td>
					         <select class="w100p" id="branchId" name="branchId">
					    </select>
					    </td>
					    <th scope="row">Payment Date</th>
					    <td>
						    <div class="date_set w100p"><!-- date_set start -->
						    <p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" name="paymentDateFr" /></p>
						    <span>To</span>
						    <p><input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" name="paymentDateTo" /></p>
						    </div><!-- date_set end -->
					    </td>
					</tr>
					<tr>
					    <th scope="row">Status</th>
					    <td>
						    <select class="multy_select w100p" multiple="multiple" id="statusId" name="statusId">
						        <option value="44">Pending</option>
						        <option value="6">Rejected</option>
						        <option value="10">Cancelled</option>
						        <option value="5">Approved</option>
						    </select>
					    </td>
					    <th scope="row"></th>
                        <td>
                        </td>
					</tr>
				</tbody>
			</table><!-- table end -->
			<aside class="link_btns_wrap"><!-- link_btns_wrap start -->
				<p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
				<dl class="link_list">
				    <dt>Link</dt>
				    <dd>
					    <!-- <ul class="btns">
					        <li><p class="link_btn"><a href="#">menu1</a></p></li>
					    </ul> -->
					    <ul class="btns">
					        <li><p class="link_btn type2"><a href="javascript:fn_depositMaintenancePop();">Deposit Maintenance</a></p></li>
					    </ul>
					    <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
				    </dd>
				</dl>
			</aside><!-- link_btns_wrap end -->
		</form>
	</section><!-- search_table end -->
	
	<section class="search_result"><!-- search_result start -->
		<article class="grid_wrap" id="master_grid_wrap"><!-- grid_wrap start -->
		</article><!-- grid_wrap end -->
	</section><!-- search_result end -->

</section><!-- content end -->

<div id="maintenance_popup_wrap" class="popup_wrap" style="display:none;"><!-- popup_wrap start -->
	<header class="pop_header"><!-- pop_header start -->
		<h1>Deposit Maintenance</h1>
		<ul class="right_opt">
		   <li><p class="btn_blue2"><a href="#" onclick="fn_hideViewPop('#maintenance_popup_wrap');">CLOSE</a></p></li>
		</ul>
	</header><!-- pop_header end -->
    <section class="pop_body"><!-- pop_body start -->
		<aside class="title_line"><!-- title_line start -->
		<h3>Reconciliation Information</h3>
		</aside><!-- title_line end -->
		
		<table class="type1"><!-- table start -->
			<caption>table</caption>
			<colgroup>
			    <col style="width:170px" />
			    <col style="width:*" />
			    <col style="width:230px" />
			    <col style="width:*" />
			</colgroup>
			<tbody>
				<tr>
				    <th scope="row">Transaction No.</th>
				    <td colspan="3"><input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" name="maintenanceTransNo" id="maintenanceTransNo" /></td>
				</tr>
				<tr>
				    <th scope="row">Reconcialition Ref Date</th>
				    <td><input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" name="maintenanceRefDate" id="maintenanceRefDate" /></td>
				    <th scope="row"> Status</th>
				    <td><input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" name="maintenanceStatus"  id="maintenanceStatus"/></td>
				</tr>
				<tr>
				    <th scope="row">Branch</th>
				    <td><input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" name="maintenanceBranch" id="maintenanceBranch"/></td>
				    <th scope="row">Bank</th>
				    <td><input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" name="maintenanceBank" id="maintenanceBank" /></td>
				</tr>
				<tr>
				    <th scope="row">Created User</th>
				    <td><input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" name="maintenanceCreUser" id="maintenanceCreUser" /></td>
				    <th scope="row">Created Date</th>
				    <td><input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" name="maintenanceCreDate" id="maintenanceCreDate" /></td>
				</tr>
			</tbody>
		</table><!-- table end -->
		<aside class="title_line"><!-- title_line start -->
		   <h3>Deposit Transaction</h3>
		</aside><!-- title_line end -->
		<section class="search_result"><!-- search_result start -->
			<article class="grid_wrap" id="maintenance_grid_wrap"><!-- grid_wrap start -->
			</article><!-- grid_wrap end -->
		</section><!-- search_result end -->
	</section>
</div>
