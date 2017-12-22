<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<script type="text/javaScript">
    var newGridID;
    
    $(document).ready(function(){
    	newGridID = GridCommon.createAUIGrid("grid_wrap_new", newColumn,null,gridPros);
    	
    	// HTML5 브라우저인지 체크 즉, FileReader 를 사용할 수 있는지 여부
        function checkHTML5Brower() {
            var isCompatible = false;
            if (window.File && window.FileReader && window.FileList && window.Blob) {
                isCompatible = true;
            }
            return isCompatible;
        }
    	
    	$("#uploadfile").on('change', function(evt) {
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
    	                    AUIGrid.setCsvGridData(newGridID, event.target.result, false);
    	                } else {
    	                	Common.alert('<spring:message code="sys.common.alert.upload.noDate"/>');
    	                }
    	            };
    	            reader.onerror = function() {
    	            	Common.alert("<spring:message code='sys.common.alert.upload.unable' arguments='"+file.fileName+"' htmlEscape='false'/>");
    	            };
    	        }
    	});
    		
    });
    
    var gridPros = {
            editable: false,
            showStateColumn: false
    };
    var newColumn=[
          {dataField:"hpCode", headerText:"hpCode"},
          {dataField:"hpType", headerText:"hpType"},
          {dataField:"isNw", headerText:"isNw"},
          {dataField:"joinYear", headerText:"joinYear"},
          {dataField:"joinMonth", headerText:"joinMonth"}
    ];

  //HTML5 브라우저 즉, FileReader 를 사용 못할 경우 Ajax 로 서버에 보냄
  //서버에서 파일 내용 읽어 반환 한 것을 통해 그리드에 삽입
  //즉, 이것은 IE 10 이상에서는 불필요 (IE8, 9 에서만 해당됨)
  function commitFormSubmit() {
	  AUIGrid.showAjaxLoader(newGridID);
	
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
	             AUIGrid.setCsvGridData(newGridID, csvText);
	             
	             AUIGrid.removeAjaxLoader(newGridID);
	         }
	     },
	     error : function(e) {
	    	 Common.alert("<spring:message code='sys.common.alert.error.ajaxSubmit' arguments='"+e+"' htmlEscape='false'/>");
	     }
	  });
  }
    
	function fn_uploadFile() {
		
	    var fileNm = $("#uploadfile").val();
        
        if(fileNm.substr(fileNm.indexOf("."),fileNm.length) != ".csv"){
        	Common.alert('<spring:message code="sys.common.alert.upload.csv"/>');
            return;
        }else{
			
			//param data array
		    var data = {};
	
		    var gridList = AUIGrid.getGridData(newGridID);       //그리드 데이터
		    
		    var num_check=/^[0-9]*$/;
		    //array에 담기        
		    if(gridList.length > 0) {
		    	for (var i = 1; i < gridList.length-1; i++) {
	                var hpCode = (gridList[i])[0];
	                var joinYear = (gridList[i])[1];
	                var joinMonth = (gridList[i])[2];
	                var joinDays = (gridList[i])[3];
	                var isNw = (gridList[i])[4];
	                
	                if(hpCode == null || hpCode == ""){
	                	Common.alert("<spring:message code='sys.common.alert.validation' arguments='HPCODE' htmlEscape='false'/>");return;
	                }else if(joinYear == null || joinYear == "" ||!(num_check.test(joinYear))){
	                	Common.alert("<spring:message code='sys.common.alert.validation' arguments='JoinYear' htmlEscape='false'/>");return;
	                }else if(joinMonth == null || joinMonth == "" || !(num_check.test(joinMonth))){
	                	Common.alert("<spring:message code='sys.common.alert.validation' arguments='JoinMonth' htmlEscape='false'/>");return;
                    }else if(joinDays == null || joinDays == "" || !(num_check.test(joinDays))){
                    	Common.alert("<spring:message code='sys.common.alert.validation' arguments='JoinDays' htmlEscape='false'/>");return;
                    }else if(isNw == null || isNw == "" || !(num_check.test(isNw))){
                    	Common.alert("<spring:message code='sys.common.alert.validation' arguments='IsNew' htmlEscape='false'/>");return;
                    }
	                    
	            }
		    	
		        data.all = gridList;
		    }  else {
		    	Common.alert('<spring:message code="sys.common.alert.upload.csv"/>');
		        return;
		    }
		    
		    //Ajax 호출
		     Common.ajax("POST", "/commission/calculation/neoUploadFile", data, function(result) {
		    	 Common.alert('<spring:message code="sys.msg.success"/>');
		        
		        document.myForm.reset();
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
		        Common.alert("<spring:message code='sys.common.alert.error.ajaxSubmit' arguments='"+jqXHR.responseJSON.message+"' htmlEscape='false'/>");
		    }); 
        }
	}
</script>

<section id="content"><!-- content start -->
	<ul class="path">
		<li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
		<li><spring:message code='commission.text.head.commission'/></li>
		<li><spring:message code='commission.text.head.upload'/></li>
		<li><spring:message code='commission.text.head.newNeopro'/></li>
	</ul>

	<aside class="title_line"><!-- title_line start -->
	<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
	<h2><spring:message code='commission.title.neoPro'/></h2>
	</aside><!-- title_line end -->


	<section class="search_table"><!-- search_table start -->
	
	   <form name="myForm" id="myForm">
			<table class="type1"><!-- table start -->
			<caption>table</caption>
			<colgroup>
			    <col style="width:130px" />
			    <col style="width:*" />
			</colgroup>
			<tbody>
			<tr>
			    <th scope="row"><spring:message code='commission.text.search.file'/></th>
			    <td>
			
			         <div class="auto_file"><!-- auto_file start -->
				         <input type="file" title="file add"  id="uploadfile" name="uploadfile"/>
			         </div><!-- auto_file end -->
			
			    </td>
			</tr>
			</tbody>
			</table><!-- table end -->
		</form>
		
	
		<ul class="center_btns">
		    <li><p class="btn_blue2 big"><a href="javascript:fn_uploadFile();"><spring:message code='commission.button.uploadFile'/></a></p></li>
		    <li><p class="btn_blue2 big"><a href="${pageContext.request.contextPath}/resources/download/NeoproUploadFormat.csv"><spring:message code='commission.button.dwFormat'/></a></p></li>
		</ul>
	    <!-- grid_wrap start -->
	    <article id="grid_wrap_new" class="grid_wrap" style="display:none;"></article>
	    <!-- grid_wrap end -->
	</section><!-- search_table end -->
</section><!-- content end -->
		
<hr />

</body>
</html>