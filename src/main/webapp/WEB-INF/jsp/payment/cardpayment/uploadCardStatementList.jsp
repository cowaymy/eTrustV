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
    var selectedGridValue;

    //Grid Properties 설정
    var gridPros = {
            // 편집 가능 여부 (기본값 : false)
            //editable : false,        
            // 상태 칼럼 사용
            showStateColumn : false,
            // 기본 헤더 높이 지정
            headerHeight : 35,
            
            softRemoveRowMode:false
    
    };
    
    //Grid Properties 설정
    var gridPros2 = {
            // 편집 가능 여부 (기본값 : false)
            editable : false,        
            // 상태 칼럼 사용
            showStateColumn : false,
            // 기본 헤더 높이 지정
            headerHeight : 35,
            
            softRemoveRowMode:false,
            
            // 체크박스 표시 설정
            showRowCheckColumn : true,
            // 전체 체크박스 표시 설정
            showRowAllCheckBox : true,
            //independentAllCheckBox : true
    
    };
    
    // AUIGrid 칼럼 설정
    var columnLayout = [ 
        {dataField : "crcStateId",headerText : "<spring:message code='pay.head.crcNo'/>",width : 100 , editable : false},
        {dataField : "bankAccName",headerText : "<spring:message code='pay.head.bankAccount'/>",width : 300 , editable : false},
        {dataField : "crcStateRefDt",headerText : "<spring:message code='pay.head.transactionDate'/>",width : 100 , editable : false, dataType:"date",formatString:"dd/mm/yyyy"},
        {dataField : "crcTotGrossAmt",headerText : "<spring:message code='pay.head.grossRm'/>",width : 100 , editable : false, dataType:"numeric", formatString:"#,##0.00"},               
        {dataField : "crcStateUploadDt",headerText : "<spring:message code='pay.head.uploadDate'/>",width : 100 , editable : false, dataType:"date",formatString:"dd/mm/yyyy"},        
        {dataField : "crcStateUploadUserNm",headerText : "<spring:message code='pay.head.uploadBy'/>",width : 240 , editable : false},
        {dataField : "crcBcStusName",headerText : "<spring:message code='pay.head.clearedStatus'/>",width : 240 , editable : false},
        {dataField : "crcStateRem",headerText : "<spring:message code='pay.head.remark'/>",editable : false},
        {dataField : "count",headerText : "",editable : false, visible : false}
        ];
        
    var detailColumnLayout = [
        {dataField : "crcTrnscId",headerText : "<spring:message code='pay.head.crcTransactionId'/>",editable : false},
        {dataField : "crcTrnscMid",headerText : "<spring:message code='pay.head.mid'/>", editable : true},                    
        {dataField : "crcTrnscDt",headerText : "<spring:message code='pay.head.trDate'/>",editable : false, dataType:"date",formatString:"dd/mm/yyyy"},                    
        {dataField : "crcTrnscNo",headerText : "<spring:message code='pay.head.cardNo'/>", editable : true},
        {dataField : "crcTrnscAppv",headerText : "<spring:message code='pay.head.approvalNo'/>", editable : true},                    
        {dataField : "crcGrosAmt",headerText : "<spring:message code='pay.head.grossRM'/>", editable : true, dataType:"numeric", formatString:"#,##0.00"},
        {dataField : "crcBcAmt",headerText : "<spring:message code='pay.head.bcRm'/>", editable : true, dataType:"numeric", formatString:"#,##0.00"},
        {dataField : "crcGstAmt",headerText : "<spring:message code='pay.head.gstRm'/>", editable : true, dataType:"numeric", formatString:"#,##0.00"},
        {dataField : "crcNetAmt",headerText : "<spring:message code='pay.head.netRm'/>", editable : true, dataType:"numeric", formatString:"#,##0.00"},
        {dataField : "crcTotBcAmt",headerText : "<spring:message code='pay.head.totalBc'/>", editable : true, dataType:"numeric", formatString:"#,##0.00"},                    
        {dataField : "crcTotGstAmt",headerText : "<spring:message code='pay.head.totalGst'/>", editable : true, dataType:"numeric", formatString:"#,##0.00"},
        {dataField : "crcTotNetAmt",headerText : "<spring:message code='pay.head.totalNet'/>", editable : true, dataType:"numeric", formatString:"#,##0.00"},
        {dataField : "count",headerText : "",editable : false, visible : false}
        ];    


    //AUIGrid 칼럼 설정
    var uploadGridLayout = [
        {dataField : "0",headerText : "<spring:message code='pay.head.mid'/>", editable : true},                    
        {dataField : "1",headerText : "<spring:message code='pay.head.creditCard'/>",editable : true},                    
        {dataField : "2",headerText : "<spring:message code='pay.head.cardNumber'/>", editable : true},
        {dataField : "3",headerText : "<spring:message code='pay.head.approvalNo'/>", editable : true},                    
        {dataField : "4",headerText : "<spring:message code='pay.head.grossRm'/>", editable : true, dataType:"numeric", formatString:"#,##0.00"},
        {dataField : "5",headerText : "<spring:message code='pay.head.bcRm'/>", editable : true, dataType:"numeric", formatString:"#,##0.00"},
        {dataField : "6",headerText : "<spring:message code='pay.head.gstRm'/>", editable : true, dataType:"numeric", formatString:"#,##0.00"},
        {dataField : "7",headerText : "<spring:message code='pay.head.netRm'/>", editable : true, dataType:"numeric", formatString:"#,##0.00"},
        {dataField : "8",headerText : "<spring:message code='pay.head.totalBc'/>", editable : true, dataType:"numeric", formatString:"#,##0.00"},                    
        {dataField : "9",headerText : "<spring:message code='pay.head.totalGst'/>", editable : true, dataType:"numeric", formatString:"#,##0.00"},
        {dataField : "10",headerText : "<spring:message code='pay.head.totalNet'/>", editable : true, dataType:"numeric", formatString:"#,##0.00"}
        ];
    
    
    $(document).ready(function(){
        
        //Credit Card Bank Account 조회
        doGetCombo('/common/getAccountList.do', 'CRC' , ''   , 'bankAccount' , 'S', '');
        
        //Upload Pop Up화면 : Credit Card Bank Account 조회
        doGetCombo('/common/getAccountList.do', 'CRC' , ''   , 'uploadBankAccount' , 'S', '');
        
        //그리드 생성
        myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout,null,gridPros2);
        myDetailGridID = GridCommon.createAUIGrid("detail_grid_wrap", detailColumnLayout,null,gridPros);
        myUploadGridID = GridCommon.createAUIGrid("grid_upload_wrap", uploadGridLayout,null,gridPros);
        
        // 셀 더블클릭 이벤트 바인딩 : 상세 팝업 
        AUIGrid.bind(myGridID, "cellDoubleClick", function(event) {
        	  selectedGridValue = event.rowIndex;
            var crcStateId = AUIGrid.getCellValue(myGridID , event.rowIndex , "crcStateId");    
            Common.ajax("GET","/payment/selectCardStatementDetailList.do", {"crcStateId" : crcStateId}, function(result){
                $("#detail_wrap").show();
                
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

   		if(FormUtil.checkReqValue($("#crcNo"))){
			if(FormUtil.checkReqValue($("#bankAccount option:selected")) &&
					FormUtil.checkReqValue($("#tranDateFr")) &&
					FormUtil.checkReqValue($("#tranDateTo")) &&
					FormUtil.checkReqValue($("#uploadDateFr")) &&
					FormUtil.checkReqValue($("#uploadDateTo")) &&
					FormUtil.checkReqValue($("#uploadUserNm")) ){
				Common.alert("<spring:message code='pay.alert.searchCondition'/>");
				return;
			}
			
			if((!FormUtil.checkReqValue($("#tranDateFr")) && FormUtil.checkReqValue($("#tranDateTo"))) ||
					(FormUtil.checkReqValue($("#tranDateFr")) && !FormUtil.checkReqValue($("#tranDateTo"))) ){
				Common.alert("<spring:message code='pay.alert.inputTransaction Date'/>");
				return;
			}
			
			if((!FormUtil.checkReqValue($("#uploadDateFr")) && FormUtil.checkReqValue($("#uploadDateTo"))) ||
					(FormUtil.checkReqValue($("#uploadDateFr")) && !FormUtil.checkReqValue($("#uploadDateTo"))) ){
				Common.alert("<spring:message code='pay.alert.inputUploadDate'/>");
				return;
			}
		}
        
        Common.ajax("POST","/payment/selectCardStatementMasterList.do",$("#searchForm").serializeJSON(), function(result){          
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
        Common.alert("<spring:message code='pay.alert.selectTransactionDate'/>");
        return;
    }

    if(FormUtil.checkReqValue($("#uploadBankAccount option:selected")) ){    
        Common.alert("<spring:message code='pay.alert.selectankAccount'/>");
        return;
    }

    if(FormUtil.checkReqValue($("#uploadRemark")) ){    
        Common.alert("<spring:message code='pay.alert.insertTheRemark'/>");
        return;
    }
    
    if(data.all.length < 1){
        Common.alert("<spring:message code='pay.alert.selectCsvFile'/>");
        return;
    }

    //Ajax 호출
    Common.confirm("<spring:message code='pay.alert.saveCrcStateForm'/>",function (){
        Common.ajax("POST", "/payment/uploadCardStatement.do", data, 
                function(result) {
                    var returnMsg = "<spring:message code='pay.alert.crcSuccessForm'/>";
   					returnMsg +=  "<br><b> CRC No : " + result.crcStateId + "</b>";

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
                    
                    Common.alert("Fail : " + jqXHR.responseJSON.message);        
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
        	Common.alert("ajaxSubmit Error : " + e);
        }
    });

}  


function cardStateDelete(){
    var checkedItems = AUIGrid.getCheckedRowItemsAll(myGridID);
    var valid = true;
    var message = "";
    if (checkedItems.length > 0){
       console.log(checkedItems);
       
       for (var i = 0 ; i < checkedItems.length ; i++){
         
           var count = Number(checkedItems[i].count);
           var crcNo = checkedItems[i].crcStateId;
           if(count == 0){
               message += "<b>CRC No : ["+ crcNo +"] Mapped Data.<br><br></b>";
               valid = false;
           }
       }
       
       if(valid){
           var data = {};
           data.all = checkedItems;
           Common.confirm("<spring:message code='pay.alert.uploadCardDelete'/>",function (){
              
             Common.ajax("POST", "/payment/deleteCardStatement.do", data, function(result) {
               
               Common.alert(result.message);
               searchList();
               
             });
             
           }); 
       }else{
          Common.alert(message);
       }
    }else{
        Common.alert("<spring:message code='pay.alert.noRecord'/>");
    }
}

function updateCardStateDetail(){
  var editedRowItems = AUIGrid.getEditedRowItems(myDetailGridID);
  console.log(editedRowItems);
  var message = "";
  var valid = true;
  if(editedRowItems.length  == 0  ||  editedRowItems == null) {
        Common.alert("<b>No Updated Data.</b>");
        return  false ;
  }

  if(editedRowItems.length > 0){
    for (var i = 0 ; i < editedRowItems.length ; i++){
       var count = Number(editedRowItems[i].count);
       var crcTrnscId = editedRowItems[i].crcTrnscId;
       if(count == 0){
          message += "<b>Tranx ID : ["+ crcTrnscId +"] Mapped Data.<br><br></b>";
          valid = false;
       }
    }
  }
  
  if(valid){
      var  updateForm ={
              "update" : editedRowItems
              }
            
      Common.ajax("POST", "/payment/updateCardStateDetail.do", updateForm, function(result) {
        console.log(result);
        Common.alert(result.message);
        });
      
  }else{
    Common.alert(message);
  }
  
}

</script>
<!-- content start -->
<section id="content">
    <ul class="path">
        <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    </ul>

    <!-- title_line start -->
    <aside class="title_line">
        <p class="fav"><a href="#" class="click_add_on"><spring:message code='pay.text.myMenu'/></a></p>
        <h2>Upload Credit Card Statement</h2>
        <ul class="right_btns">
           <c:if test="${PAGE_AUTH.funcChange == 'Y'}">
                <li><p class="btn_blue"><a href="javascript:showUploadPop();"><spring:message code='pay.btn.newUpload'/></a></p></li>
                <li><p class="btn_blue"><a href="javascript:cardStateDelete();"><spring:message code='pay.btn.delete'/></a></p></li>         
           </c:if> 
            <c:if test="${PAGE_AUTH.funcView == 'Y'}">
                <li><p class="btn_blue"><a href="javascript:searchList();"><span class="search"></span><spring:message code='sys.btn.search'/></a></p></li>
            </c:if>
            <li><p class="btn_blue"><a href="javascript:clear();"><span class="clear"></span><spring:message code='sys.btn.clear'/></a></p></li>
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
                        <th scope="row">CRC No.</th>
                        <td>
                            <input type="text" id="crcNo" name="crcNo" title="" placeholder="" class="w100p" />
                        </td>
                        <th scope="row"></th>
                        <td></td>
                    </tr>
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
                        <td><input type="text" id="uploadUserNm" name="uploadUserNm" title="" placeholder="Upload User Name" class="w100p"  /></td>
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
        <h1>Credit Card Statement Item</h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a href="#" onclick="updateCardStateDetail();"><spring:message code='sys.btn.save'/></a></p></li>
            <li><p class="btn_blue2"><a href="#" onclick="hideViewPopup('#detail_wrap')"><spring:message code='sys.btn.close'/></a></p></li>
        </ul>
    </header>
    <!-- pop_header end -->

    <!-- pop_body start -->
    <section class="pop_body">
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
        <h1>Upload Credit Card Statement</h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a href="#" onclick="hideViewPopup('#upload_wrap')"><spring:message code='sys.btn.close'/></a></p></li>
        </ul>
    </header>
    <!-- pop_header end -->

    <!-- getParams  -->
    <section class="pop_body">
        <ul class="right_btns mb10">
            <li><p class="btn_blue2"><a href="${pageContext.request.contextPath}/resources/download/payment/CreditCardStatement_Format.csv"><spring:message code='pay.btn.downloadTemplate'/></a></p></li>            
            <li><p class="btn_blue2"><a href="javascript:uploadClear();"><spring:message code='sys.btn.clear'/></a></p></li>
            <li><p class="btn_blue2"><a href="javascript:upload();"><spring:message code='pay.btn.upload'/></a></p></li>
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
                        <th scope="row">Transaction Date</th>
                        <td>
                            <input type="text" id="uploadTranDt" name="uploadTranDt" title="Transaction Date" placeholder="DD/MM/YYYY" class="j_date w100p" />
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
                                <input type="file" id="fileSelector" title="file add" accept=".csv" />
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