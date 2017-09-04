<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
    
<script type="text/javaScript">

var myGridID,newBatchAdjGridID;

//Default Combo Data
var adjTypeData = [{"codeId": "1293","codeName": "Credit Note"},{"codeId": "1294","codeName": "Debit Note"}];

//Grid Properties 설정 
var gridPros = {            
        editable : false,                 // 편집 가능 여부 (기본값 : false)
        showStateColumn : false     // 상태 칼럼 사용
};

var columnLayout=[    
    { dataField:"batchId" ,headerText:"Batch ID" ,editable : false},
    { dataField:"memoAdjRefNo" ,headerText:"CN/DN No." ,editable : false },
    { dataField:"memoAdjInvcNo" ,headerText:"Invoice No." ,editable : false },
    { dataField:"invcItmOrdNo" ,headerText:"Order No." ,editable : false},
    { dataField:"memoItmAmt" ,headerText:"Adjustment Amount(RM)" ,editable : false },
    { dataField:"resnDesc" ,headerText:"Reason" ,editable : false },
    { dataField:"userName" ,headerText:"Requestor" ,editable : false },
    { dataField:"deptName" ,headerText:"Department" ,editable : false },
    { dataField:"memoAdjCrtDt" ,headerText:"Request Create Date" ,editable : false },    
    { dataField:"code1" ,headerText:"Status" ,editable : false },
    { dataField:"memoAdjRem" ,headerText:"Remark" ,editable : false }
    ];

var newBatchColLayout = [ 
    {dataField : "0", headerText : "Invoice Number", editable : true},
    {dataField : "1", headerText : "Order Number", editable : true},
    {dataField : "2", headerText : "Item ID", editable : true},
    {dataField : "3", headerText : "Adjustment Amount", editable : true, dataType : "numeric", formatString : "#,##0.00"}
    ];

// 화면 초기화 함수 (jQuery 의 $(document).ready(function() {}); 과 같은 역할을 합니다.
$(document).ready(function(){
	
	 //Adjustment Type 생성
    doDefCombo(adjTypeData, '' ,'newAdjType', 'S', '');            

    //Adjustment Type 변경시 Reason Combo 생성
    $('#newAdjType').change(function (){
        $("#newAdjReason option").remove();        

        if($(this).val() != ""){
            var param = $(this).val() == "1293" ? "1584" : "1585"; 
            doGetCombo('/common/selectAdjReasontList.do', param , ''   , 'newAdjReason' , 'S', '');
        }
    });
    
    //Grid 생성
	myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout,null,gridPros);
	newBatchAdjGridID = GridCommon.createAUIGrid("newBatchAdj_grid_wrap", newBatchColLayout,null,gridPros);
	

    
    // 파일 선택하기
    $('#fileSelector').on('change', function(evt) {
        if (!checkHTML5Brower()) {
            // 브라우저가 FileReader 를 지원하지 않으므로 Ajax 로 서버로 보내서
            // 파일 내용 읽어 반환시켜 그리드에 적용.
            commitFormSubmit();
            
            //alert("브라우저가 HTML5 를 지원하지 않습니다.");
        } else {
            var data = null;
            var file = evt.target.files[0];
            if (typeof file == "undefined") {
                return;
            }
            var reader = new FileReader();
            //reader.readAsText(file); // 파일 내용 읽기
            reader.readAsText(file, "EUC-KR"); // 한글 엑셀은 기본적으로 CSV 포맷인 EUC-KR 임. 한글 깨지지 않게 EUC-KR 로 읽음
            reader.onload = function(event) {
                if (typeof event.target.result != "undefined") {
                    // 그리드 CSV 데이터 적용시킴
                    AUIGrid.setCsvGridData(newBatchAdjGridID, event.target.result, false);
                } else {
                    alert('No data to import!');
                }
            };
            reader.onerror = function() {
                alert('Unable to read ' + file.fileName);
            };
        }
    
        });
    

  
	
});

// HTML5 브라우저인지 체크 즉, FileReader 를 사용할 수 있는지 여부
function checkHTML5Brower() {
    var isCompatible = false;
    if (window.File && window.FileReader && window.FileList && window.Blob) {
        isCompatible = true;
    }
    return isCompatible;
};

//HTML5 브라우저 즉, FileReader 를 사용 못할 경우 Ajax 로 서버에 보냄
//서버에서 파일 내용 읽어 반환 한 것을 통해 그리드에 삽입
//즉, 이것은 IE 10 이상에서는 불필요 (IE8, 9 에서만 해당됨)
function commitFormSubmit() {
    
	AUIGrid.showAjaxLoader(newBatchAdjGridID);
 
	 // Submit 을 AJax 로 보내고 받음.
	 // ajaxSubmit 을 사용하려면 jQuery Plug-in 인 jquery.form.js 필요함
	 // 링크 : http://malsup.com/jquery/form/
 
    $('#updResultForm').ajaxSubmit({
    	type : "json",
    	success : function(responseText, statusText) {
    		if(responseText != "error") {
    			var csvText = responseText;
    			
    			// 기본 개행은 \r\n 으로 구분합니다.
    			// Linux 계열 서버에서 \n 으로 구분하는 경우가 발생함.
    			// 따라서 \n 을 \r\n 으로 바꿔서 그리드에 삽입
    			// 만약 서버 사이드에서 \r\n 으로 바꿨다면 해당 코드는 불필요함. 
                csvText = csvText.replace(/\r?\n/g, "\r\n")
             
                // 그리드 CSV 데이터 적용시킴
                AUIGrid.setCsvGridData(newBatchAdjGridID, csvText);
                AUIGrid.removeAjaxLoader(newBatchAdjGridID);
            }
    		   },
    		   error : function(e) {
    			   alert("ajaxSubmit Error : " + e);
    			   }
    		   });
 
 }  

// 리스트 조회.
function fn_getAdjustmentListAjax() {
	if(FormUtil.checkReqValue($("#batchId"))){
        Common.alert('* Please select the batch ID<br />');
        return;
    }
	
    Common.ajax("GET", "/payment/selectAdjustmentList.do", $("#searchForm").serialize(), function(result) {
        AUIGrid.setGridData(myGridID, result);
    });
}

//New Batch Adjustment Pop-UP
function fn_openDivPop(){
	$("#newBatchAdj_wrap").show();  
                
}

//Layer close
hideViewPopup=function(val){
	AUIGrid.destroy(newBatchAdjGridID);
	newBatchAdjGridID = GridCommon.createAUIGrid("newBatchAdj_grid_wrap", newBatchColLayout,null,gridPros);
	$("#newBatchAdjForm")[0].reset();
    $(val).hide();
}

//Save
function fn_batchAdjFileUp(){
	
	 //param data array
    var data = GridCommon.getGridData(newBatchAdjGridID);
    data.form = $("#newBatchAdjForm").serializeJSON();
    
      
    if(FormUtil.checkReqValue($("#newAdjType option:selected")) ){ 
        Common.alert('* Please select the adjustment type.<br />');
        return;
    }
    
    if(FormUtil.checkReqValue($("#newAdjReason option:selected")) ){    
        Common.alert('* Please select the adjustment reason.<br />');
        return;
    }
    
    if(FormUtil.checkReqValue($("#newRemark")) ){    
        Common.alert('* Please select the adjustment remark.<br />');
        return;
    }
    
    if(data.all.length < 1){
    	Common.alert('* Select the CSV file on the loca PC<br />');
        return;
    }
    
    //Ajax 호출
    Common.ajax("POST", "/payment/saveBatchNewAdjList.do", data, function(result) {
        var returnMsg = "CN/DN request is sent<br> ";
        returnMsg += "Kindly refer to request reference no. <br> ";
        returnMsg += "<b>BATCH ID is : " + result.data+ " </b><br> ";
        
        Common.alert(returnMsg, function (){
        	hideViewPopup('#newBatchAdj_wrap');
        });
        
    },  function(jqXHR, textStatus, errorThrown) {
        try {
            console.log("status : " + jqXHR.status);
            console.log("code : " + jqXHR.responseJSON.code);
            console.log("message : " + jqXHR.responseJSON.message);
            console.log("detailMessage : " + jqXHR.responseJSON.detailMessage);
        } catch (e) {
            console.log(e);
        }
        alert("Fail : " + jqXHR.responseJSON.message);        
    });
    
}
</script>

<!-- content start -->
<section id="content">
    <ul class="path">
        <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
        <li>Payment</li>
        <li>Invoice/Statement</li>
        <li>Batch Adjustment (CN/DN)</li>
    </ul>

    <!-- title_line start -->
    <aside class="title_line">
        <p class="fav"><a href="#" class="click_add_on">My menu</a></p>
        <h2>Batch Invoice Adjustment (CN / DN)</h2>
        <ul class="right_btns">
            <li><p class="btn_blue"><a href="javascript:fn_getAdjustmentListAjax();"><span class="search"></span>Search</a></p></li>
        </ul>
    </aside>
    <!-- title_line end -->

    <!-- search_table start -->
    <section class="search_table">
        <form name="searchForm" id="searchForm"  method="post">
            <table class="type1"><!-- table start -->
                <caption>table</caption>
				<colgroup>
				    <col style="width:180px" />
				    <col style="width:*" />
				    <col style="width:180px" />
				    <col style="width:*" />				    
				</colgroup>
				<tbody>
				    <tr>
				        <th scope="row">Batch ID.</th>
					    <td>
					       <input id="batchId" name="batchId" type="text" placeholder="Batch Id." class="w100p" />
					    </td>
					    <th scope="row">Adjustment Status</th>
                        <td>
                            <select id="status" name="status" class="w100p">
                                <option value="1">Active</option>
                                <option value="4">Completed</option>
                                <option value="21">Failed</option>
                            </select>
                        </td>
                    </tr>
					<tr>
					   <th scope="row">Request Name</th>
					   <td>
					       <input id="creator" name="creator" type="text" placeholder="Request Name." class="w100p" />
                        </td>
					    <th scope="row">Department Name</th>
                        <td>
                           <input id="deptNm" name="deptNm" type="text" placeholder="Department Name" class="w100p" />
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
                        <li><p class="link_btn"><a href="javascript:fn_openDivPop();">New Batch</a></p></li>                                                                                              
                    </ul>
                    <ul class="btns">                                 
                    </ul>
                    <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
                    </dd>
                </dl>
            </aside>
            <!-- link_btns_wrap end -->
        </form>
    </section>
    <!-- search_table end -->

    <!-- search_result start -->
    <section class="search_result">	
        <!-- grid_wrap start -->
        <article id="grid_wrap" class="grid_wrap"></article>
        <!-- grid_wrap end -->
    </section>
    <!-- search_result end -->
</section>



<!--------------------------------------------------------------- 
    POP-UP (NEW Batch ADJUSTMENT)
---------------------------------------------------------------->
<!-- popup_wrap start -->
<div class="popup_wrap" id="newBatchAdj_wrap" style="display:none;">
    <!-- pop_header start -->
    <header class="pop_header" id="newBatchAdj_header">
        <h1>NEW BATCH ADJUSTMENT</h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a href="#" onclick="hideViewPopup('#newBatchAdj_wrap')">CLOSE</a></p></li>
        </ul>
    </header>
    <!-- pop_header end -->
    
    <!-- pop_body start -->
    <form name="newBatchAdjForm" id="newBatchAdjForm"  method="post">
    <section class="pop_body">
        <!-- search_table start -->
        <section class="search_table">
            <!-- table start -->
            <table class="type1">
                <caption>table</caption>
                 <colgroup>
                    <col style="width:165px" />
                    <col style="width:*" />                
                    <col style="width:165px" />
                    <col style="width:*" />
                </colgroup>
                <tbody>
                    <tr>
                        <th scope="row">Request ID</th>
                        <td>
                        </td>
                        <th scope="row">Department</th>
                        <td>                            
                        </td>
                    </tr>
                    <tr>
                       <th scope="row">Adjustment Type</th>
                        <td>
                            <select id="newAdjType" name="newAdjType" ></select>
                        </td>
                        <th scope="row">Reason</th>
                        <td>
                            <select id="newAdjReason" name="newAdjReason"></select>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Remark</th>
                        <td colspan="3">
                            <textarea id="newRemark" name="newRemark"></textarea>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">File</th>
                        <td colspan="3">
                            <!-- auto_file start -->
                           <div class="auto_file">
                               <input type="file" id="fileSelector" title="file add" accept=".csv" />
                           </div>
                           <!-- auto_file end -->
                        </td>
                    </tr>
                   </tbody>  
            </table>
        </section>
        
        <section class="search_result"><!-- search_result start -->
            <article class="grid_wrap"  id="newBatchAdj_grid_wrap"  style="display:none;"></article>             
            <!-- grid_wrap end -->
        </section><!-- search_result end -->
        <!-- search_table end -->
        
        <ul class="center_btns" >
            <li><p class="btn_blue2"><a href="javascript:fn_batchAdjFileUp();">Upload File</a></p></li>
            <li><p class="btn_blue2"><a href="#">Download CSV Format</a></p></li>
        </ul>
    </section>
    </form>       
    <!-- pop_body end -->
</div>
<!-- popup_wrap end -->
