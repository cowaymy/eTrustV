<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<script type="text/javaScript">

//AUIGrid 그리드 객체
var myGridID;

//AUIGrid 칼럼 설정
var columnLayout = [ 
    {         
        dataField : "0",
        headerText : "<spring:message code='pay.head.transactionDate'/>",
        editable : true
    },{
        dataField : "1",
        headerText : "<spring:message code='pay.head.crcNumber'/>",
        editable : true
    },{
        dataField : "2",
        headerText : "<spring:message code='pay.head.approvalNo'/>",
        editable : true
    }, {
        dataField : "3",
        headerText : "<spring:message code='pay.head.midNo'/>",
        editable : true
    }, {
        dataField : "4",
        headerText : "<spring:message code='pay.head.refNo'/>",
        editable : true
    }, {
        dataField : "5",
        headerText : "<spring:message code='pay.head.grossAmount'/>",
        dataType : "numeric",
        editable : true
    }];

// 화면 초기화 함수 (jQuery 의 $(document).ready(function() {}); 과 같은 역할을 합니다.
$(document).ready(function(){
	   
	// HTML5 브라우저인지 체크 즉, FileReader 를 사용할 수 있는지 여부
    function checkHTML5Brower() {
        var isCompatible = false;
        if (window.File && window.FileReader && window.FileList && window.Blob) {
            isCompatible = true;
        }
        return isCompatible;
    };
    
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
                    AUIGrid.setCsvGridData(myGridID, event.target.result, false);
                } else {
                    alert('No data to import!');
                }
            };
            reader.onerror = function() {
                alert('Unable to read ' + file.fileName);
            };
        }
    });
    
    // AUIGrid 그리드를 생성합니다.
    createAUIGrid(columnLayout);
});

//AUIGrid 를 생성합니다.
function createAUIGrid(columnLayout) {
    
    // 그리드 속성 설정
    var gridPros = {
        
        selectionMode : "multipleCells",
        
        useContextMenu : true,
        
        enableFilter : true,
        
        // 편집 가능 여부 (기본값 : false)
        editable : true,
    
        // 상태 칼럼 사용
        //showStateColumn : true,
        
        displayTreeOpen : true,
        
        noDataMessage : "Select the CSV file on the local PC.",
        
    };

    // 실제로 #grid_wrap 에 그리드 생성
    myGridID = AUIGrid.create("#grid_wrap", columnLayout, gridPros);
    
    // 그리드 최초에 빈 데이터 넣음.
    AUIGrid.setGridData(myGridID, []);
}

//HTML5 브라우저 즉, FileReader 를 사용 못할 경우 Ajax 로 서버에 보냄
//서버에서 파일 내용 읽어 반환 한 것을 통해 그리드에 삽입
//즉, 이것은 IE 10 이상에서는 불필요 (IE8, 9 에서만 해당됨)
function commitFormSubmit() {
 
 AUIGrid.showAjaxLoader(myGridID);
 
 // Submit 을 AJax 로 보내고 받음.
 // ajaxSubmit 을 사용하려면 jQuery Plug-in 인 jquery.form.js 필요함
 // 링크 : http://malsup.com/jquery/form/
 
 $('#myForm').ajaxSubmit({
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
             AUIGrid.setCsvGridData(myGridID, csvText);
             
             AUIGrid.removeAjaxLoader(myGridID);
         }
     },
     error : function(e) {
         alert("ajaxSubmit Error : " + e);
     }
 });
};


//수정 처리
function fn_saveGridMap(){
	
	//필수항목 입력여부	
	if($("#crcStateRefDt").val() == ''){
		alert("* Reference Date are composulary field . ");
		return;
	}
	
	if($("#crcStateCardAccount").val() == ''){
	     alert("* CRC Bank Account Code are composulary field . ");
	     return;
	 }
	
	 if($("#crcStateAccId").val() == ''){
	     alert("* Account Code are composulary field . ");
	     return;
	 }
	 
	//param data array
	var data = {};

    var gridList = AUIGrid.getGridData(myGridID);       //그리드 데이터
	var formList = $("#myForm").serializeArray();       //폼 데이터
    
    //array에 담기        
    if(gridList.length > 0) {
    	data.all = gridList;
    }  else {
    	alert('Select the CSV file on the loca PC');
    	return;
    	//data.all = [];
    }
	
    if(formList.length > 0) data.form = formList;
    else data.form = [];
	
    //Ajax 호출
    Common.ajax("POST", "/payment/updateCRCStatementUpload.do", data, function(result) {
        Common.setMsg(result.message);  
        resetUpdatedItems(); // 초기화
        
        
        
    },  function(jqXHR, textStatus, errorThrown) {
        try {
            console.log("status : " + jqXHR.status);
            console.log("code : " + jqXHR.responseJSON.code);
            console.log("message : " + jqXHR.responseJSON.message);
            console.log("detailMessage : "
                    + jqXHR.responseJSON.detailMessage);
        } catch (e) {
            console.log(e);
        }
        alert("Fail : " + jqXHR.responseJSON.message);        
    });
}

//그리드 초기화.
function resetUpdatedItems() {
     AUIGrid.resetUpdatedItems(myGridID, "a");
 }
 
 
 

//수정 처리
function fn_testCallStoredProcedure(){
	//param data array
    var data = {};
  //Ajax 호출
  Common.ajax("POST", "/payment/testCallStoredProcedure.do", data, function(result) {
      Common.setMsg(" success ");
      
      resetUpdatedItems(); // 초기화
      
      
      
  },  function(jqXHR, textStatus, errorThrown) {
      try {
          console.log("status : " + jqXHR.status);
          console.log("code : " + jqXHR.responseJSON.code);
          console.log("message : " + jqXHR.responseJSON.message);
          console.log("detailMessage : "
                  + jqXHR.responseJSON.detailMessage);
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
        <li><img src="${pageContext.request.contextPath}/resources/image/path_home.gif" alt="Home" /></li>
        <li>Payment</li>
        <li>Reconciliation</li>
        <li>CRC Statement Upload</li>
    </ul>

	<!-- title_line start -->
	<aside class="title_line">
		<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
		<h2>CRC Statement Upload</h2>
		<ul class="right_opt">
			<li><p class="btn_blue multy"><a href="${pageContext.request.contextPath}/resources/download/CRC_Statement.csv"><spring:message code='pay.btn.download'/><br /><spring:message code='pay.btn.csvFileFormat'/></a></p></li>
			<li><p class="btn_blue"><a href="javascript:fn_saveGridMap();"><spring:message code='sys.btn.save'/></a></p></li>
			<li><p class="btn_blue"><a href="javascript:fn_testCallStoredProcedure();"><spring:message code='pay.btn.spTest'/></a></p></li>
			
		</ul>
	</aside>
	<!-- title_line end -->

    <!-- search_table start -->
    <section class="search_table">
        <form name="myForm" id="myForm">
            <!-- table start -->
            <table class="type1">
                <caption>search table</caption>
                <colgroup>
					<col style="width:144px" />
					<col style="width:*" />
                </colgroup>
                <tbody>
	                <tr>
	                    <th scope="row">Reference Date</th>
	                    <td><input type="text" name="crcStateRefDt" id="crcStateRefDt" title="Reference Date" placeholder="DD/MM/YYYY" class="j_date" /></td>
	                </tr>
	                <tr>
	                    <th scope="row">Card Account</th>
	                    <td>
	                        <select id="crcStateCardAccount" name="crcStateCardAccount">
	                            <option value="" selected>Select CRC Account</option>
	                            <c:forEach var="crcList" items="${ cardComboList}" varStatus="status">
	                                <option value="${crcList.accDesc}">${crcList.accDesc}</option>
	                            </c:forEach>
	                        </select>
	                    </td>
	                </tr>
	                <tr>
	                    <th scope="row">Account No</th>
	                    <td>
	                        <select id="crcStateAccId" name="crcStateAccId">
	                            <option value="" selected>Select Account</option>
	                            <c:forEach var="bankList" items="${ bankComboList}" varStatus="status">
	                                <option value="${bankList.accId}">${bankList.accDesc2}</option>
	                            </c:forEach>                                
	                        </select>
	                    </td>
	                </tr>
	                <tr>
	                    <th scope="row">SCV File</th>
	                    <td>	                       
	                       <!-- auto_file start -->
	                       <div class="auto_file">
	                           <input type="file" id="fileSelector" title="file add" accept=".csv" />
                           </div>
                           <!-- auto_file end -->
	                    
	                    </td>
	                </tr>
	            </tbody>
	        </table>
	        <!-- table end -->
	        <!-- 
	        <ul class="right_btns">
	           <li><p class="btn_gray"><a href="#"><span class="search"></span>Search</a></p></li>
            </ul>
             -->
        </form>
    </section>
    <!-- search_table end -->
    
    <!-- search_result start -->
    <section class="search_result">
        <!-- link_btns_wrap start -->
        <aside class="link_btns_wrap">
            <p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/image/btn_link.gif" alt="link show" /></a></p>
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
                    <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/image/btn_link_close.gif" alt="hide" /></a></p>
                </dd>
            </dl>
        </aside>
        <!-- link_btns_wrap end -->
        <!--  
        <ul class="right_btns">
		    <li><p class="btn_grid"><a href="#">EXCEL UP</a></p></li>
		    <li><p class="btn_grid"><a href="#">EXCEL DW</a></p></li>
		    <li><p class="btn_grid"><a href="#">DEL</a></p></li>
		    <li><p class="btn_grid"><a href="#">INS</a></p></li>
		    <li><p class="btn_grid"><a href="#">Add</p></li>
        </ul>
        -->
        <!-- grid_wrap start -->
        <article id="grid_wrap" class="grid_wrap"></article>
        <!-- grid_wrap end -->
        
         <!-- bottom_msg_box start -->
        <aside class="bottom_msg_box">            
        </aside>
        <!-- bottom_msg_box end -->
    
    </section>
    <!-- search_result end -->

</section>
<!-- content end -->