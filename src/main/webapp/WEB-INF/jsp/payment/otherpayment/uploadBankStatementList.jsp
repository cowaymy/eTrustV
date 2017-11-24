<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<style type="text/css">
.my-custom-up div{
    color:#FF0000;
}
</style>
<script type="text/javaScript">
	//AUIGrid 그리드 객체
	var myGridID;
	var myDetailGridID;
	var myUploadGridID;

	//Grid Properties 설정
	var gridPros = {
	        // 편집 가능 여부 (기본값 : false)
	        editable : false,        
	        // 상태 칼럼 사용
	        showStateColumn : false,
	        // 기본 헤더 높이 지정
	        headerHeight : 35,
	        
	        softRemoveRowMode:false
	
	};

	// AUIGrid 칼럼 설정
	var columnLayout = [ 
	    {dataField : "bsNo",headerText : "BS No.",width : 100 , editable : false},
	    {dataField : "bankName",headerText : "Bank",width : 160 , editable : false},
	    {dataField : "bankAccName",headerText : "Bank Account",width : 240 , editable : false},
	    {dataField : "trnscDt",headerText : "Transaction<br>Date",width : 100 , editable : false, dataType:"date",formatString:"dd/mm/yyyy"},
	    {dataField : "updDt",headerText : "Upload<br>Date",width : 100 , editable : false, dataType:"date",formatString:"dd/mm/yyyy"},
	    {dataField : "count",headerText : "Count",width : 80 , editable : false, dataType:"numeric", formatString:"#,##0"},
	    {dataField : "remark",headerText : "Remark",editable : false}
	    ];
	    
	var detailColumnLayout = [
	    {dataField : "bankId",headerText : "Bank ID",editable : false, visible : false},
	    {dataField : "bankAcc",headerText : "Bank Account Code", editable : false, visible : false},
	    
	    {dataField : "bankName",headerText : "Bank", editable : false},                    
	    {dataField : "bankAccName",headerText : "Bank Account.",editable : false},                    
	    {dataField : "fTrnscDt",headerText : "Date/<br>Time", editable : false, dataType:"date",formatString:"dd/mm/yyyy"},
	    {dataField : "fTrnscTellerId",headerText : "Teller ID", editable : false},
	    {dataField : "fTrnscRef3",headerText : "Transaction Code",editable : false},
	    {dataField : "fTrnscRefChqNo",headerText : "Ref/<br>Cheq No", editable : false},
	    {dataField : "fTrnscRef1",headerText : "Description", editable : false},
	    {dataField : "fTrnscRef2",headerText : "ref6", editable : false},
        {dataField : "fTrnscRef6",headerText : "ref7", editable : false},                    
        {dataField : "fTrnscRem",headerText : "Type", editable : false},
        {dataField : "fTrnscDebtAmt",headerText : "Debit", editable : false, dataType:"numeric", formatString:"#,##0.00"},
        {dataField : "fTrnscCrditAmt",headerText : "Credit", editable : false, dataType:"numeric", formatString:"#,##0.00"},
	    {dataField : "fTrnscRef4",headerText : "Deposit Slip No / EFT / MID", editable : false},
	    {dataField : "fTrnscNewChqNo",headerText : "Chq No", editable : false},
	    {dataField : "fTrnscRefVaNo",headerText : "VA number", editable : false}
	    ];    

    //AUIGrid 칼럼 설정
	var uploadGridLayout = [
		{dataField : "0", headerText : "Teller ID", editable : true},
		{dataField : "1", headerText : "Transaction Code", editable : true},
		{dataField : "2", headerText : "Ref/Cheq No", editable : true},
		{dataField : "3", headerText : "Description", editable : true},
		{dataField : "4", headerText : "ref6", editable : true},
        {dataField : "5", headerText : "ref7", editable : true},
        {dataField : "6", headerText : "TYPE", editable : true},
        {dataField : "7", headerText : "Debit", editable : true},
        {dataField : "8", headerText : "Credit", editable : true},        
		{dataField : "9", headerText : "Deposit Slip No/EFT/MID", editable : true},
		{dataField : "10", headerText : "Chq No", editable : true},
		{dataField : "11", headerText : "VA number", editable : true}
		];
    
    
	$(document).ready(function(){
		
		//Issue Bank 조회
	    doGetCombo('/common/getAccountList.do', 'CASH' , ''   , 'bankAccount' , 'S', '');
		
		//Upload Pop Up화면 : Bank 조회    
	    doGetCombo('/common/getIssuedBankList.do', '' , ''   , 'uploadIssueBank' , 'S', '');
		
		//Upload Pop Up화면 : Bank Account 조회
	    doGetCombo('/common/getAccountList.do', 'CASH' , ''   , 'uploadBankAccount' , 'S', '');
		
		//그리드 생성
	    myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout,null,gridPros);
	    myDetailGridID = GridCommon.createAUIGrid("detail_grid_wrap", detailColumnLayout,null,gridPros);
	    myUploadGridID = GridCommon.createAUIGrid("grid_upload_wrap", uploadGridLayout,null,gridPros);
	    
	    // 셀 더블클릭 이벤트 바인딩 : 상세 팝업 
        AUIGrid.bind(myGridID, "cellDoubleClick", function(event) {
        	
        	var bsNo = AUIGrid.getCellValue(myGridID , event.rowIndex , "bsNo");	
            Common.ajax("GET","/payment/selectBankStatementDetailList.do", {"bsNo" : bsNo}, function(result){
            	$("#detail_wrap").show();
            	$("#pop_bsNo").text(bsNo);
                AUIGrid.setGridData(myDetailGridID, result);
                AUIGrid.resize(myDetailGridID);
            });
        });
	    

      //**************************************************
      //** 업로드 파일 내용을 Grid에 적용하기
      //**************************************************
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
                      AUIGrid.setCsvGridData(myUploadGridID, event.target.result, false);
                      
                      //csv 파일이 header가 있는 파일이면 첫번째 행(header)은 삭제한다.
                      AUIGrid.removeRow(myUploadGridID,0);
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

    // ajax list 조회.
    function searchList(){
    	
    	if(FormUtil.checkReqValue($("#bankAccount option:selected")) &&
        		FormUtil.checkReqValue($("#tranDateFr")) &&
        		FormUtil.checkReqValue($("#tranDateTo")) &&
        		FormUtil.checkReqValue($("#uploadDateFr")) &&
        		FormUtil.checkReqValue($("#uploadDateTo")) &&
        		FormUtil.checkReqValue($("#uploadUserNm")) ){
            Common.alert('* Please input search condition <br />');
            return;
        }
        
        if((!FormUtil.checkReqValue($("#tranDateFr")) && FormUtil.checkReqValue($("#tranDateTo"))) ||
                (FormUtil.checkReqValue($("#tranDateFr")) && !FormUtil.checkReqValue($("#tranDateTo"))) ){
            Common.alert('* Please input Transaction Date <br />');
            return;
        }
        
        if((!FormUtil.checkReqValue($("#uploadDateFr")) && FormUtil.checkReqValue($("#uploadDateTo"))) ||
                (FormUtil.checkReqValue($("#uploadDateFr")) && !FormUtil.checkReqValue($("#uploadDateTo"))) ){
            Common.alert('* Please input Upload Date <br />');
            return;
        }
    	
    	Common.ajax("POST","/payment/selectBankStatementMasterList.do",$("#searchForm").serializeJSON(), function(result){    		
    		AUIGrid.setGridData(myGridID, result);
    	});
    }
    
    // 화면 초기화
    function clear(){
    	//화면내 모든 form 객체 초기화
    	$("#searchForm")[0].reset();
    	$("#uploadForm")[0].reset();
    	
    	//그리드 초기화
    	//AUIGrid.clearGridData(myGridID);
    	//AUIGrid.clearGridData(myDetailGridID);
    	//AUIGrid.clearGridData(myUploadGridID);
    	
    	//팝업내 컬럼 초기화
    	$("#pop_bsNo").text("");        
    }
    
    // upload 화면 초기화
    function uploadClear(){
        //화면내 모든 form 객체 초기화
        $("#uploadForm")[0].reset();
        
        //그리드 초기화
        AUIGrid.clearGridData(myUploadGridID);        
    }
    
  //Layer close
  hideViewPopup=function(val){       
      $(val).hide();
      
      //업로드창이 닫히면 upload 화면도 reset한다. 
      if(val == '#upload_wrap'){    	  
    	  uploadClear();
      }
  }
  
  // Upload 버튼 클릭시 업로드 팝업
  function showUploadPop(){
	  $("#upload_wrap").show();
	  AUIGrid.resize(myUploadGridID);	  	  
  }
    
//Upload 버튼 클릭시 업로드 팝업
function upload(){
    //param data array
    var data = GridCommon.getGridData(myUploadGridID);
    data.form = $("#uploadForm").serializeJSON();
    
    if(FormUtil.checkReqValue($("#uploadTranDt")) ){
        Common.alert('* Please select the Transaction Date.<br />');
        return;
    }

    if(FormUtil.checkReqValue($("#uploadIssueBank option:selected")) ){
        Common.alert('* Please select the Bank Code.<br />');
        return;
    }

    if(FormUtil.checkReqValue($("#uploadBankAccount option:selected")) ){    
        Common.alert('* Please select the Bank Account.<br />');
        return;
    }

    if(FormUtil.checkReqValue($("#uploadRemark")) ){    
        Common.alert('* Please insert the Remark<br />');
        return;
    }
    
    if(data.all.length < 1){
        Common.alert('* Select the CSV file on the loca PC<br />');
        return;
    }

    //Ajax 호출
    Common.confirm('<b>Are you sure want to upload this Bank Statement items?</b>',function (){
    	Common.ajax("POST", "/payment/uploadBankStatement.do", data, 
                function(result) {
                    var returnMsg = "This Bank Statement form has successfully been uploaded.";
        
                    Common.alert(returnMsg, function (){
                        hideViewPopup('#upload_wrap');
                    });
        
                },  
                function(jqXHR, textStatus, errorThrown) {
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
    });    
	   
}

//**************************************************
//** 업로드 파일 내용을 Grid에 적용하기
//**************************************************
//HTML5 브라우저인지 체크 즉, FileReader 를 사용할 수 있는지 여부
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

    AUIGrid.showAjaxLoader(myUploadGridID);

    // Submit 을 AJax 로 보내고 받음.
    // ajaxSubmit 을 사용하려면 jQuery Plug-in 인 jquery.form.js 필요함
    // 링크 : http://malsup.com/jquery/form/

    $('#uploadForm').ajaxSubmit({
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
                AUIGrid.setCsvGridData(myUploadGridID, csvText);
                AUIGrid.removeAjaxLoader(myUploadGridID);
                
                //csv 파일이 header가 있는 파일이면 첫번째 행(header)은 삭제한다.
                AUIGrid.removeRow(myUploadGridID,0);
            }
        },
        error : function(e) {
            alert("ajaxSubmit Error : " + e);
        }
    });

}  


</script>
<!-- content start -->
<section id="content">
    <ul class="path">
        <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
        <li>Payment</li>
        <li>Other Payment</li>        
        <li>Upload Bank Statement</li>
    </ul>

    <!-- title_line start -->
    <aside class="title_line">
        <p class="fav"><a href="#" class="click_add_on">My menu</a></p>
        <h2>Upload Bank Statement</h2>
        <ul class="right_btns">
            <li><p class="btn_blue"><a href="javascript:showUploadPop();">New Upload</a></p></li>
            <li><p class="btn_blue"><a href="javascript:searchList();"><span class="search"></span>Search</a></p></li>     
            <li><p class="btn_blue"><a href="javascript:clear();"><span class="clear"></span>Clear</a></p></li>
        </ul>
    </aside>
    <!-- title_line end -->

    <!-- search_table start -->
    <section class="search_table">
        <!-- search_table start -->
        <form id="searchForm" action="#" method="post">
            <table class="type1">
                <caption>table</caption>
                <colgroup>
                    <col style="width:180px" />
                    <col style="width:*" />
                    <col style="width:180px" />
                    <col style="width:*" />
                </colgroup>
                <tbody>
                    <tr>
                        <th scope="row">Transaction Date</th>
                        <td>
                            <!-- date_set start -->
                            <div class="date_set w100p">
                            <p><input type="text" id="tranDateFr" name="tranDateFr" title="Transaction Start Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
                            <span>To</span>
                            <p><input type="text" id="tranDateTo" name="tranDateTo" title="Transaction End Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
                            </div>
                            <!-- date_set end -->
                        </td>
                        <th scope="row">Upload By</th>
                        <td><input type="text" id="uploadUserNm" name="uploadUserNm" title="" placeholder="Upload User Name" class="w100p" /></td>
                    </tr>
                    <tr>
                        <th scope="row">Bank Account</th>
                        <td>  
                            <select id="bankAccount" name="bankAccount" class="w100p">                                                               
                            </select>
                        </td>
                        <th scope="row">Upload Date</th>
                        <td>
                            <!-- date_set start -->
                            <div class="date_set w100p">
                            <p><input type="text" id="uploadDateFr" name="uploadDateFr" title="Upload Start Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
                            <span>To</span>
                            <p><input type="text" id="uploadDateTo" name="uploadDateTo" title="Upload End Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
                            </div>
                            <!-- date_set end -->
                        </td>
                        
                    </tr>
                </tbody>
            </table>
            <!-- table end -->
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
<!-- content end -->



<!--------------------------------------------------------------- 
POP-UP (DETAIL)
---------------------------------------------------------------->
<!-- popup_wrap start -->
<div class="popup_wrap" id="detail_wrap" style="display:none;">
    <!-- pop_header start -->
    <header class="pop_header" id="detail_pop_header">
        <h1>Bank Statement Item</h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a href="#" onclick="hideViewPopup('#detail_wrap')">CLOSE</a></p></li>
        </ul>
    </header>
    <!-- pop_header end -->

    <!-- pop_body start -->
    <section class="pop_body">
        <!-- search_table start -->
        <section class="search_table">
            <!-- table start -->
            <table class="type1">
                <caption>table</caption>
                <colgroup>
                    <col style="width:165px" />
                    <col style="width:*" />                
                </colgroup>
                <tbody>
                    <tr>
                        <th scope="row">BS No</th>
                        <td id="pop_bsNo"></td>
                    </tr>
                </tbody>  
            </table>
        </section>

        <section class="search_result">
            <article class="grid_wrap"  id="detail_grid_wrap"></article>  
        </section>
        <!-- search_table end -->
    </section>
    <!-- pop_body end -->
</div>
<!-- popup_wrap end -->


<!--------------------------------------------------------------- 
POP-UP (UPLOAD)
---------------------------------------------------------------->
<!-- popup_wrap start -->
<div id="upload_wrap" class="popup_wrap" style="display:none;">
    <!-- pop_header start -->
    <header class="pop_header">
        <h1>Upload Bank Statement</h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a href="#" onclick="hideViewPopup('#upload_wrap')">CLOSE</a></p></li>
        </ul>
    </header>
    <!-- pop_header end -->

    <!-- getParams  -->
    <section class="pop_body">
        <ul class="right_btns mb10">
            <li><p class="btn_blue2"><a href="${pageContext.request.contextPath}/resources/download/payment/BankStatement_Format.csv">Download Template</a></p></li>            
            <li><p class="btn_blue2"><a href="javascript:uploadClear();">Clear</a></p></li>
            <li><p class="btn_blue2"><a href="javascript:upload();">Upload</a></p></li>
        </ul>

        <!-- pop_body start -->
        <form id="uploadForm"> 
            <!-- table start -->
            <table class="type1">
                <caption>table</caption>
                <colgroup>
                    <col style="width:150px" />
                    <col style="width:*" />
                    <col style="width:150px" />
                    <col style="width:*" />
                </colgroup>
                <tbody>
                    <tr>
                        <th scope="row">B/S No.</th>
                        <td>
                            <input type="text"  id="uploadBsNo" name="uploadBsNo" title="" placeholder="" class="w100p readonly" readonly="readonly" />
                        </td>
                        <th scope="row">Transaction Date</th>
                        <td>
                            <input type="text" id="uploadTranDt" name="uploadTranDt" title="Transaction Date" placeholder="DD/MM/YYYY" class="j_date w100p" />
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Bank Code</th>
                        <td>
                            <select id="uploadIssueBank" name="uploadIssueBank" class="w100p"></select>
                        </td>
                        <th scope="row">Bank Account</th>
                        <td>  
                            <select id="uploadBankAccount" name="uploadBankAccount" class="w100p"></select>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Upload File</th>
                        <td colspan="3">
                            <!-- auto_file start -->
                            <div class="auto_file">
                                <input type="file" id="fileSelector" title="file add" accept=".csv"/>
                            </div>
                            <!-- auto_file end -->
                        </td>                        
                    </tr>
                    <tr>
                        <th scope="row">Remark</th>
                        <td colspan="3"><input type="text" id="uploadRemark" name="uploadRemark" title="Remark" placeholder="Remark" class="w100p" /></td>                            
                    </tr>                 
                </tbody>
            </table>
            <!-- table end -->
        </form>
        <!--Form End  -->

        <!-- search_result start -->
        <section class="search_result">
            <!-- grid_wrap start -->
            <article id="grid_upload_wrap" class="grid_wrap"></article>
            <!-- grid_wrap end -->
        </section>
        <!-- search_result end -->


    </section>
    <!-- pop_body end -->
</div>
<!-- popup_wrap end -->