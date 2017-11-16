<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<script type="text/javaScript">
//AUIGrid 그리드 객체
var myGridID;
var pendingGridID;
var isMapped;
var selectedItem;

var gridPros = {
        // 편집 가능 여부 (기본값 : false)
        editable : false,
        // 상태 칼럼 사용
        showStateColumn : false,
        
        //체크박스컬럼
        showRowCheckColumn : true,
        showRowAllCheckBox : false,
        rowCheckToRadio : true
};

var gridPros2 = {
        // 편집 가능 여부 (기본값 : false)
        editable : false,
        // 상태 칼럼 사용
        showStateColumn : false,
        height:100
};

$(document).ready(function(){
	myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout,null,gridPros);
	pendingGridID = GridCommon.createAUIGrid("grid_wrap_pending", columnPending,null,gridPros2);
	/*AUIGrid.bind(myGridID, "cellClick", function(event) {
        var item = event.item;
        var rowIdField;
        var rowId;
        
        rowIdField = AUIGrid.getProp(event.pid, "rowField"); // rowIdField 얻기
        rowId = item[rowIdField];
        
        alert(event.pid + ", " + rowId);
        AUIGrid.addCheckedRowsByIds(event.pid, rowId);
        //AUIGrid.addUncheckedRowsByIds(event.pid, rowId);
    });*/
    
    
    //doGetCombo('/common/getIssuedBankList.do', '' , ''   , 'bankType' , 'S', '');
    
    AUIGrid.bind(myGridID, "rowCheckClick", function( event ) {
        //alert("rowIndex : " + event.rowIndex + ", id : " + event.item.stus + ", name : " + event.item.name + ", checked : " + event.checked);
        selectedItem = event.item.id;
        isMapped = event.item.stus;
    });
    
	var strAcc = '<select id="bankAcc" name="bankAcc" class="w100p"></select>';
	 $("#cash_cheque").show();
	 $("#cash_cheque").find("#acc").html(strAcc);
	 doGetCombo('/common/getAccountList.do', 'CASH','', 'bankAcc', 'S', '' );
	 
	 $('#payMode').change(function() {
		 
         //alert($('#payMode').val());
		 //cash일때, online<div>감추고 Cash에 대한 Bank Acc불러옴
		 if($('#payMode').val() == '105'){
			 $("#online").hide();
             $("#cash_cheque").show();
             
             $('#cash_cheque').find('#acc').html("");
             $('#online').find('#acc').html("");
             $('#cash_cheque').find('#acc').html(strAcc);
             doGetCombo('/common/getAccountList.do', 'CASH','', 'bankAcc', 'S', '' );
	     }else if($('#payMode').val() == '106'){//cheque
	    	 $("#online").hide();
	         $("#cash_cheque").show();
	         
	         $('#cash_cheque').find('#acc').html("");
             $('#online').find('#acc').html("");
             $('#cash_cheque').find('#acc').html(strAcc);
	         doGetCombo('/common/getAccountList.do', 'CHQ','', 'bankAcc', 'S', '' );
	     }else if($('#payMode').val() == '108'){//online
	    	 $("#cash_cheque").hide(); 
             $("#online").show();
             
             $('#cash_cheque').find('#acc').html("");
             $('#online').find('#acc').html("");
             $('#online').find('#acc').html(strAcc);
             doGetCombo('/common/getAccountList.do', 'ONLINE','', 'bankAcc', 'S', '' );
        }
		 
	 });
     
	 $('#online').find('#bankType').change(function(){
		 //alert("online : " + $('#online').find('#bankType').val());
		 if($('#online').find('#bankType').val() == 'VA'){
			 $('#online').find('#bankAcc').prop("disabled", true);
			 $('#online').find('#va').prop("disabled", false);
		 }else{
			 $('#online').find('#bankAcc').prop("disabled", false);
             $('#online').find('#va').prop("disabled", true); 
		 }
	 });
	 
	 $('#cash_cheque').find('#bankType').change(function(){
		 //alert("cash_cheque : " + $('#cash_cheque').find('#bankType').val());
		 if($('#cash_cheque').find('#bankType').val() == 'VA'){
             $('#cash_cheque').find('#bankAcc').prop("disabled", true);
             $('#cash_cheque').find('#va').prop("disabled", false);
         }else{
             $('#cash_cheque').find('#bankAcc').prop("disabled", false);
             $('#cash_cheque').find('#va').prop("disabled", true); 
         }
	 });
});

var columnPending=[
	{
        dataField : "bank",
        headerText : "Bank",
        editable : false,
    },{
        dataField : "bankAccount",
        headerText : "Bank Account",
        editable : false,
    },{
        dataField : "date",
        headerText : "Date",
        editable : false,
    },
    {
        dataField : "mode",
        headerText : "Mode",
        editable : false,
    },
    {
        dataField : "amount",
        headerText : "Amount",
        editable : false,
    },
    {
        dataField : "trId",
        headerText : "Transaction ID",
        editable : false,
    },
    {
        dataField : "pendingAmount",
        headerText : "Pending Amount",
        editable : false,
    }
];

// AUIGrid 칼럼 설정
var columnLayout = [ 
     {
         dataField : "id",
         headerText : "id",
         editable : false,
         visible : false
     },
    {
        dataField : "bank",
        headerText : "Bank",
        editable : false
    }, {
        dataField : "bankAccName",
        headerText : "Bank Account",
        editable : false
    }, {
        dataField : "trnscDt",
        headerText : "Date",
        editable : false,
        dataType:"date",
        formatString:"yyyy-mm-dd"
    }, 
    {
        dataField : "fTrnscTellerId",
        headerText : "Teller ID",
        editable : false
    }, 
    {
        dataField : "ref3",
        headerText : "Transaction Code",
        editable : false
    }, 
    {
        dataField : "chqNo",
        headerText : "Ref/Cheque No.",
        editable : false
    }, {
        dataField : "ref1",
        headerText : "Description",
        editable : false
    },  {
        dataField : "ref2",
        headerText : "Ref6",
        editable : false
    }, {
        dataField : "ref6",
        headerText : "Ref7",
        editable : false
    },{
        dataField : "type",
        headerText : "Type",
        editable : false
    },{
        dataField : "debt",
        headerText : "Debt",
        editable : false
    },{
        dataField : "crdit",
        headerText : "Crdit",
        editable : false
    },{
        dataField : "stus",
        headerText : "Status",
        editable : false,
        renderer : {
            type : "IconRenderer",
            iconPosition:"aisle",
            iconWidth : 15, // icon 가로 사이즈, 지정하지 않으면 24로 기본값 적용됨
            iconHeight : 15,
            iconFunction : function(rowIndex, columnIndex, value, item) {
                switch(value) {
                case "Mapped":
                	return"${pageContext.request.contextPath}/resources/images/common/path_home.gif";
                default : 
                    return null;
                }
            }
        }
    },{
        dataField : "othKeyInMappingDt",
        headerText : "Mapped Date",
        editable : false,
        dataType:"date",
        formatString:"yyyy-mm-dd"
    },{
        dataField : "ref4",
        headerText : "Deposit Slip No / EFT /MID",
        editable : false
    },{
        dataField : "fTrnscNewChqNo",
        headerText : "Chq No",
        editable : false
    },{
        dataField : "fTrnscRefVaNo",
        headerText : "VA number",
        editable : false
    }
    ];

    function fn_clear(){
    	$("#searchForm")[0].reset();
    	AUIGrid.clearGridData(myGridID);
    }
    
    function fn_searchList(){
    	if($("#bankDateFr").val() != '' && $("#bankDateTo").val() != ''){
	    	Common.ajax("GET","/payment/selectBankStatementList.do",$("#searchForm").serializeJSON(), function(result){         
	            AUIGrid.setGridData(myGridID, result);
	        });
	    }//else{Common.alert("key in Bank In Date..");}
    }
    
    function fn_mapping(){
    	var data = {};
    	if(isMapped == 'Mapped'){
    		Common.alert("This item has already been confirmed payment.");
    	}else{
    		if($('#payMode').val() == '105' || $('#payMode').val() == '106'){
    			data = {
    					"bank" : $("#cash_cheque").find("#bankType").val() , 
    					"bankAccount" : $("#cash_cheque").find("#bankAcc option:selected").text(),
    					"date" : $("#cash_cheque").find("#trDate").val(),
    					"mode" : $("#payMode option:selected").text(),
    					"amount" : $("#cash_cheque").find("#amount").val(),
    					"pendingAmount":$("#cash_cheque").find("#amount").val()
    			};
    			AUIGrid.setGridData(pendingGridID, data);
    		}else if($('#payMode').val() == '108'){
    			data = {
                        "bank" : $("#online").find("#bankType").val() , 
                        "bankAccount" : $("#online").find("#bankAcc option:selected").text(),
                        "date" : $("#online").find("#trDate").val(),
                        "mode" : $("#payMode option:selected").text(),
                        "amount" : $("#online").find("#amount").val(),
                        "pendingAmount":$("#online").find("#amount").val() + $("#online").find("#chargeAmount").val()
                };
    			AUIGrid.setGridData(pendingGridID, data);
            }
    		
    		$("#page1").hide();
    		$("#page2").show();
    		AUIGrid.resize(pendingGridID);
    		
    		 
    	}
    }
    
</script>
<!-- content start -->
<section id="content">
<div id="page1">
    <ul class="path">
        <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
        <li>Payment</li>
        <li>Batch Payment</li>
    </ul>
    <!-- title_line start -->
    <aside class="title_line">
		<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
		<h2>Other Payment</h2>
		<ul class="right_btns">
		    <li><p class="btn_blue"><a href="#" onclick="fn_mapping();">Mapping</a></p></li>
		    <li><p class="btn_blue"><a href="#" onclick="fn_searchList();"><span class="search"></span>Search</a></p></li>
		    <li><p class="btn_blue"><a href="#" onclick="fn_clear();"><span class="clear"></span>Clear</a></p></li>
		</ul>
	</aside><!-- title_line end -->
    <!-- search_table start -->
    <section class="search_table"><!-- search_table start -->
		<form id="searchForm" action="#" method="post">
			<table class="type1"><!-- table start -->
				<caption>table</caption>
				<colgroup>
				    <col style="width:170px" />
				    <col style="width:*" />
				</colgroup>
				<tbody>
                    <tr>
                           <th>Bank In Date</th>
                           <td>
                                <!-- date_set start -->
	                            <div class="date_set">
		                            <p><input type="text" id="bankDateFr" name="bankDateFr" title="Bank In Start Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
		                            <span>To</span>
		                            <p><input type="text" id="bankDateTo" name="bankDateTo" title="Bank In End Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
	                            </div>
	                            <!-- date_set end -->
                           </td>
                    </tr>
				</tbody>
			</table>
			<!-- table end -->
			<!-- link_btns_wrap start -->
			<aside class="link_btns_wrap">
				<p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
				<dl class="link_list">
				    <dt>Link</dt>
				    <dd>
				    <ul class="btns">
				        <li><p class="link_btn"><a href="javascript:fn_uploadPopup();">Upload Batch Payment</a></p></li>
				        <li><p class="link_btn"><a href="javascript:fn_viewBatchPopup();">View Batch Payment</a></p></li>
				        <li><p class="link_btn"><a href="javascript:fn_confirmBatchPopup();">Confirm Batch Payment</a></p></li>
				    </ul>
				    <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
				    </dd>
				</dl>
			</aside><!-- link_btns_wrap end -->
		</form>
	</section><!-- search_table end -->
    <!-- search_result start -->
    <section class="search_result">
        <!-- grid_wrap start -->
        <article id="grid_wrap" class="grid_wrap"></article>
        <!-- grid_wrap end -->
    </section>
    <!-- search_result end -->
    <table class="type1"><!-- table start -->
        <caption>table</caption>
        <colgroup>
            <col style="width:170px" />
            <col style="width:*" />
        </colgroup>
        <tbody>
            <tr>
                <th scope="row">Payment Mode</th>
                <td>
                    <select id="payMode" name="payMode" class="w100p">
                        <option value="105">Cash</option>
                        <option value="106">Cheque</option>
                        <option value="108">On-line</option>
                    </select>
                </td>
            </tr>
        </tbody>
    </table>
       
<div id="online" style="display:none;">
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
                <th scope="row">Amount</th>
                <td>
                   <input type="text" id="amount" name="amount" class="w100p"  />
                </td>
                <th scope="row">Bank Charge Amount</th>
                <td>
                   <input type="text" id="chargeAmount" name="chargeAmount" class="w100p"  />
                </td>
            </tr>
            <tr>
                <th scope="row">Bank Type</th>
                <td colspan="3">
                    <select id="bankType" name="bankType" class="w100p" >
                        <option value="JomPay">JomPay</option>
                        <option value="MBBCDM">MBB CDM</option>
                        <option value="VA">VA</option>
                        <option value="Others">Others</option>
                    </select>
                </td>
            </tr>
            <tr>
                   <th>Bank Account</th>
                   <td id="acc"></td>
                   <th>VA Account</th>
                   <td><input type="text" id="va" name="va" class="w100p"/></td>
            </tr>
            <tr>
                   <th>Transaction Date</th>
                   <td colspan="3"><input type="text" id="trDate" name="trDate" class="w100p"/></td>
            </tr>
            <tr>
                   <th>Remark</th>
                   <td colspan="3"><input type="text" name="remark" id="remark" class="w100p"/></td>
            </tr>
            <tr>
                 <th>EFT</th>
                 <td colspan="3"><input type="text" name="eft" id="eft" class="w100p"/></td>
            </tr>
        </tbody>
    </table>
</div>
<div id="cash_cheque" style="display:none;">
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
                <th scope="row">Amount</th>
                <td colspan="3">
                   <input type="text" id="amount" name="amount" class="w100p"  />
                </td>
            </tr>
            <tr>
                <th scope="row">Slip No.</th>
                <td colspan="3">
                   <input type="text" id="slipNo" name="spliNo" class="w100p"  />
                </td>
            </tr>
            <tr>
                <th scope="row">Bank Type</th>
                <td colspan="3">
                    <select id="bankType" name="bankType" class="w100p" >
                        <option value="JomPay">JomPay</option>
                        <option value="MBBCDM">MBB CDM</option>
                        <option value="VA">VA</option>
                        <option value="Others">Others</option>
                    </select>
                </td>
            </tr>
            <tr>
                   <th>Bank Account</th>
                   <td id="acc"></td>
                   <th>VA Account</th>
                   <td><input type="text" id="va" name="va" class="w100p"/></td>
            </tr>
            <tr>
                   <th>Transaction Date</th>
                   <td colspan="3"><input type="text" id="trDate" name="trDate" class="w100p"/></td>
            </tr>
            <tr>
                   <th>Remark</th>
                   <td colspan="3"><input type="text" name="remark" id="remark" class="w100p"/></td>
            </tr>
        </tbody>
    </table>
    </div>
 </div>
 <div id="page2" style="display:none;">
<!-- grid_wrap start -->
        <article id="grid_wrap_pending" class="grid_wrap"></article>
<!-- grid_wrap end -->
 </div>
</section>


