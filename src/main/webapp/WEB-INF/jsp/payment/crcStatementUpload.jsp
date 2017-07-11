<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<script type="text/javaScript">

//AUIGrid 그리드 객체
var myGridID;

//AUIGrid 칼럼 설정
var columnLayout = [ 
    {         
        dataField : "0",
        headerText : "Transaction Date",
        editable : true
    },{
        dataField : "1",
        headerText : "CRC Number",
        editable : true
    },{
        dataField : "2",
        headerText : "Approval No.",
        editable : true
    }, {
        dataField : "3",
        headerText : "MID No.",
        editable : true
    }, {
        dataField : "4",
        headerText : "Ref No.",
        editable : true
    }, {
        dataField : "5",
        headerText : "Gross Amount",
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
        showStateColumn : true,
        
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
    Common.ajax("POST", "/payment/updateCRCStatementUpload.do", GridCommon.getGridData(myGridID), function(result) {
        alert("UPDATE SUCCESS");
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
</script>
<!-- content start -->
<div id="content">
    <ul class="path">
        <li><img src="${pageContext.request.contextPath}/resources/image/path_home.gif" alt="Home" /></li>
        <li>Payment</li>
        <li>Reconciliation</li>
        <li>Credit Card Statement</li>
    </ul>

    <!-- title_line start -->
    <div class="title_line">
        <p class="fav"><img src="${pageContext.request.contextPath}/resources/image/icon_star.gif" alt="즐겨찾기" /></p>
        <h2>CRC Statement Upload</h2>
        <ul class="right_opt">
            <li><p class="btn_blue multy"><a href="${pageContext.request.contextPath}/resources/download/CRC_Statement.csv">Download<br />CSV File Format</a></p></li>
            <li><p class="btn_blue"><a href="javascript:fn_saveGridMap();">Save</a></p></li>
        </ul>
    </div>
    <!-- title_line end -->

    <!-- search_table start -->
    <div class="search_table">
          <form name="myForm" id="myForm">
            <!-- table start -->
            <table summary="search table" class="type1">
                <caption>search table</caption>
				<colgroup>
				    <col style="width:144px" />
				    <col style="width:*" />
				</colgroup>
				<tbody>
					<tr>
					    <th scope="row">Reference Date</th>
					    <td><input type="text" name="refDt" id="refDt" size="10" />
					    </td>
					</tr>
                    <tr>
                        <th scope="row">Card Account</th>
                        <td>
                            <select id="cardAccount" name="cardAccount">
                                <option value="" selected>Select CRC Account</option>
                                <c:forEach var="crcList" items="${ cardComboList}" varStatus="status">
                                    <option value="${crcList.accId}">${crcList.accDesc2}</option>
                                </c:forEach>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Account No</th>
                        <td>
                             <select id="account" name="account">
                                <option value="" selected>Select Account</option>
                                <c:forEach var="bankList" items="${ bankComboList}" varStatus="status">
                                    <option value="${bankList.accId}">${bankList.accDesc2}</option>
                                </c:forEach>                                
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">SCV File</th>
                        <td><input type="file" id="fileSelector" name="files" accept=".csv"><p class="btn_sky"><a href="#">File</a></p></td>
                    </tr>
                   </tbody>
               </table>
               <!-- table end -->
            </form>
        </div>
        <!-- search_table end -->

        <!-- search_result start -->
        <div class="search_result">          
            <!-- grid_wrap start -->
            <div id="grid_wrap" style="width:100%; height:480px; margin:0 auto;"></div>
            <!-- grid_wrap end -->
        </div>
        <!-- search_result end -->
</div>
<!-- content end -->