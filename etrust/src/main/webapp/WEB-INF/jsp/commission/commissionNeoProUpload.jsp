<!DOCTYPE html>
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
    	                    alert('No data to import!');
    	                }
    	            };
    	            reader.onerror = function() {
    	                alert('Unable to read ' + file.fileName);
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
	         alert("ajaxSubmit Error : " + e);
	     }
	  });
  }
    
	function fn_uploadFile() {
		
	    var fileNm = $("#uploadfile").val();
        
        if(fileNm.substr(fileNm.indexOf("."),fileNm.length) != ".csv"){
            Common.alert('Select the CSV file on the loca PC');
            return;
        }else{
			
			//param data array
		    var data = {};
	
		    var gridList = AUIGrid.getGridData(newGridID);       //그리드 데이터
		    
		    //array에 담기        
		    if(gridList.length > 0) {
		        data.all = gridList;
		    }  else {
		        Common.alert('Select the CSV file on the loca PC');
		        return;
		    }
		    
		    //Ajax 호출
		    Common.ajax("POST", "/commission/calculation/neoUploadFile", data, function(result) {
		        Common.alert(result.message);
		        
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
		        alert("Fail : " + jqXHR.responseJSON.message);        
		    });
        }
	}
	
</script>

<div id="wrap"><!-- wrap start -->

<header id="header"><!-- header start -->
<ul class="left_opt">
	<li>Neo(Mega Deal): <span>2394</span></li> 
	<li>Sales(Key In): <span>9304</span></li> 
	<li>Net Qty: <span>310</span></li>
	<li>Outright : <span>138</span></li>
	<li>Installment: <span>4254</span></li>
	<li>Rental: <span>4702</span></li>
	<li>Total: <span>45080</span></li>
</ul>
<ul class="right_opt">
	<li>Login as <span>KRHQ9001-HQ</span></li>
	<li><a href="#" class="logout">Logout</a></li>
	<li><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/top_btn_home.gif" alt="Home" /></a></li>
	<li><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/top_btn_set.gif" alt="Setting" /></a></li>
</ul>
</header><!-- header end -->
<hr />
		
<section id="container"><!-- container start -->

<aside class="lnb_wrap"><!-- lnb_wrap start -->

<header class="lnb_header"><!-- lnb_header start -->
<form action="#" method="post">
<h1><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/logo.gif" alt="eTrust system" /></a></h1>
<p class="search">
<input type="text" title="검색어 입력" />
<input type="image" src="${pageContext.request.contextPath}/resources/images/common/icon_lnb_search.gif" alt="검색" />
</p>

</form>
</header><!-- lnb_header end -->

<section class="lnb_con"><!-- lnb_con start -->
<p class="click_add_on_solo on"><a href="#">All menu</a></p>
<ul class="inb_menu">
	<li class="active">
	<a href="#" class="on">menu 1depth</a>

	<ul>
		<li class="active">
		<a href="#" class="on">menu 2depth</a>

		<ul>
			<li class="active">
			<a href="#" class="on">menu 3depth</a>
			</li>
			<li>
			<a href="#">menu 3depth</a>
			</li>
			<li>
			<a href="#">menu 3depth</a>
			</li>
			<li>
			<a href="#">menu 3depth</a>
			</li>
			<li>
			<a href="#">menu 3depth</a>
			</li>
			<li>
			<a href="#">menu 3depth</a>
			</li>
		</ul>

		</li>
		<li>
		<a href="#">menu 2depth</a>
		</li>
		<li>
		<a href="#">menu 2depth</a>
		</li>
		<li>
		<a href="#">menu 2depth</a>
		</li>
		<li>
		<a href="#">menu 2depth</a>
		</li>
		<li>
		<a href="#">menu 2depth</a>
		</li>
	</ul>

	</li>
	<li>
	<a href="#">menu 1depth</a>
	</li>
	<li>
	<a href="#">menu 1depth</a>
	</li>
	<li>
	<a href="#">menu 1depth</a>
	</li>
	<li>
	<a href="#">menu 1depth</a>
	</li>
	<li>
	<a href="#">menu 1depth</a>
	</li>
</ul>
<p class="click_add_on_solo"><a href="#"><span></span>My menu</a></p>
<ul class="inb_menu">
	<li>
	<a href="#">My menu 1depth</a>
	</li>
	<li>
	<a href="#">My menu 1depth</a>
	</li>
	<li>
	<a href="#">My menu 1depth</a>
	</li>
	<li>
	<a href="#">My menu 1depth</a>
	</li>
	<li>
	<a href="#">My menu 1depth</a>
	</li>
	<li>
	<a href="#">My menu 1depth</a>
	</li>
</ul>
</section><!-- lnb_con end -->

</aside><!-- lnb_wrap end -->

<section id="content"><!-- content start -->
<ul class="path">
	<li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
	<li>Sales</li>
	<li>Order list</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>commission NeoPro Upload - New Upload</h2>
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
			    <th scope="row">File</th>
			    <td>
			
			         <div class="auto_file"><!-- auto_file start -->
				         <input type="file" title="file add"  id="uploadfile" name="uploadfile"/>
			         </div><!-- auto_file end -->
			
			    </td>
			</tr>
			</tbody>
			</table><!-- table end -->
		</form>
		
	</section><!-- search_table end -->
	
	<ul class="center_btns">
	    <li><p class="btn_blue2 big"><a href="javascript:fn_uploadFile();">Upload File</a></p></li>
	    <li><p class="btn_blue2 big"><a href="#">Download Format</a></p></li>
	</ul>
    <!-- grid_wrap start -->
    <article id="grid_wrap_new" class="grid_wrap" style="display:none;"></article>
    <!-- grid_wrap end -->
</section><!-- content end -->
		
</section><!-- container end -->
<hr />

</div><!-- wrap end -->