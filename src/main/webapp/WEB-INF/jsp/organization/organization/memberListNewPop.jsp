<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">

function fn_memberSave(){
			    var jsonObj =  GridCommon.getEditData(myGridID);
			    jsonObj.form = $("#memberAddForm").serializeJSON();
			    Common.ajax("POST", "/organization/memberSave",  jsonObj, function(result) {
		console.log("message : " + result.message );
		Common.alert(result.message);
	});
}

function fn_docSubmission(){
	Common.ajax("GET", "/organization/selectHpDocSubmission",  $("#memberType").serialize(), function(result) {
		console.log("성공.");
        console.log("data : " + result);
        AUIGrid.setGridData(myGridID, result);
        AUIGrid.resize(myGridID,1000,400); 
    });
}

function fn_departmentCode(value){
	var action = value;
	switch(action){
	   case "1" :
		   var jsonObj = {
	            memberLvl : 3,
	            flag :  "%CRS%"
	    };
		   doGetCombo("/organization/selectDeptCode", jsonObj , ''   , 'deptCd' , 'S', '');
		   break;
	   case "2" :
           var jsonObj = {
                memberLvl : 3,
                flag :  "%CCS%"
        };
           doGetCombo("/organization/selectDeptCode", jsonObj , ''   , 'deptCd' , 'S', '');
           doGetComboSepa("/common/selectBranchCodeList.do",4 , '-',''   , 'branch' , 'S', '');
           break;
	   case "3" :
           var jsonObj = {
                memberLvl : 3,
                flag :  "%CTS%"
        };
           doGetCombo("/organization/selectDeptCode", jsonObj , ''   , 'deptCd' , 'S', '');
           doGetComboSepa("/common/selectBranchCodeList.do",2 , '-',''   , 'branch' , 'S', '');
           break;
           
	   case "4" :
           var jsonObj = {
                memberLvl : 100,
                flag :  "-"
        };
           doGetComboSepa("/common/selectBranchCodeList.do",100 , '-',''   , 'branch' , 'S', '');
           break;
	}
}
$(document).ready(function() {
	  createAUIGridDoc();
	fn_docSubmission();
	fn_departmentCode();
	$("#state").change(function (){
		var state = $("#state").val();
		doGetComboAddr('/common/selectAddrSelCodeList.do', 'area' ,state ,'','area', 'S', '');  
	});
	$("#area").change(function (){
        var area = $("#area").val();
        doGetComboAddr('/common/selectAddrSelCodeList.do', 'post' ,area ,'','postCode', 'S', '');  
    });
	
	$("#memberType").change(function (){
        var memberType = $("#memberType").val();
        fn_departmentCode(memberType);
    });
	
	
	/* $("#state").change(function() {
		//doGetCombo('/common/selectAddrSelCode.do','area'  ,  '' , 'area' , 'S', '');
		
		  var jsonObj = {
		           codevalue : $("#state").val()
		    };
		Common.ajax("GET", "/organization/selectArea", jsonObj, function(result) {
		$("#area").find('option').each(function() {
			var list = new Object();
			list.id = result.id;
            list.value = result.text();
			area.push(list);
		 });
	    console.log("성공.");
	    console.log("data : " + result);
		alert($("#state").val());
	    }); 
	});*/
	
});
function createAUIGridDoc() {
    //AUIGrid 칼럼 설정
    var columnLayout = [ {
        dataField : "codeName",
        headerText : "Document",
        editable : false,
        width : 120
    }, {
        dataField : "",
        headerText : "Submission",
        editable : false,
        width : 130,
        renderer : {
            type : "CheckBoxEditRenderer",
            showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
            editable : false, // 체크박스 편집 활성화 여부(기본값 : false)
            checkValue : "1", // true, false 인 경우가 기본
            unCheckValue : "0",
         // 체크박스 Visible 함수
            checkableFunction  : function(rowIndex, columnIndex, value, isChecked, item, dataField) {
            	if(item.c1 == 1){
	            	AUIGrid.updateRow(myGridID, { 
	            		  "c1" : "0" 
	            		}, rowIndex); 
            	}else{
            		AUIGrid.updateRow(myGridID, { 
                        "c1" : "1" 
                      }, rowIndex); 
            	}
                return true;
            }
            
        }
    }, {
        dataField : "c1",
        headerText : "Qty",
        editable : false,
        width : 130
    }];
     // 그리드 속성 설정
    var gridPros = {
        
        // 페이징 사용       
        usePaging : true,
        
        // 한 화면에 출력되는 행 개수 20(기본값:20)
        pageRowCount : 20,
        
        editable : true,
        
        showStateColumn : true, 
        
        displayTreeOpen : true,
        
        
        headerHeight : 30,
        
        // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
        skipReadonlyColumns : true,
        
        // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
        wrapSelectionMove : true,
        
        // 줄번호 칼럼 렌더러 출력
        showRowNumColumn : false,

    };
    
    //myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout, gridPros);
    myGridID = AUIGrid.create("#grid_wrap_doc", columnLayout, gridPros);
}

var gridPros = {
    
    // 페이징 사용       
    usePaging : true,
    
    // 한 화면에 출력되는 행 개수 20(기본값:20)
    pageRowCount : 20,
    
    editable : true,
    
    fixedColumnCount : 1,
    
    showStateColumn : true, 
    
    displayTreeOpen : true,
    
    selectionMode : "singleRow",
    
    headerHeight : 30,
    
    // 그룹핑 패널 사용
    useGroupingPanel : true,
    
    // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
    skipReadonlyColumns : true,
    
    // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
    wrapSelectionMove : true,
    
    // 줄번호 칼럼 렌더러 출력
    showRowNumColumn : false,
    
};

</script>
</head>
<body>

<div id="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Member List - Add New Member</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->
<form action="#" id="memberAddForm" method="post">
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Member Type</th>
    <td>
    <select class="w100p" id="memberType" name="memberType">
        <option value="1">Health Planner (HP)</option>
        <option value="2">Coway Lady (Cody)</option>
        <option value="3">Coway Technician (CT)</option>
        <option value="4">Coway Staff (Staff)</option>
    </select>
    </td>
</tr>
</tbody>
</table><!-- table end -->

<section class="tap_wrap"><!-- tap_wrap start -->
<ul class="tap_type1 num4">
    <li><a href="#" class="on">Basic Info</a></li>
    <li><a href="#">Spouse Info</a></li>
    <li><a href="#">Document Submission</a></li>
</ul>

<article class="tap_area"><!-- tap_area start -->

<aside class="title_line"><!-- title_line start -->
<h2>Basic Information</h2>
</aside><!-- title_line end -->
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:160px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Member Name<span class="must">*</span></th>
    <td colspan="3">
    <input type="text" title="" id="memberNm" name="memberNm" placeholder="Member Name" class="w100p" />
    </td>
    <th scope="row">Joined Date<span class="must">*</span></th>
    <td>
    <input type="text" title="Create start Date" id="joinDate" name="joinDate" placeholder="DD/MM/YYYY" class="j_date" />
    </td>
</tr>
<tr>
    <th scope="row">Gender<span class="must">*</span></th>
    <td>
    <label><input type="radio" name="gender" id="gender" value="M" /><span>Male</span></label>
    <label><input type="radio" name="gender" id="gender" value="F"/><span>Female</span></label>
    </td>
    <th scope="row">Date of Birth<span class="must">*</span></th>
    <td>
    <input type="text" title="Create start Date" id="Birth" name="Birth"placeholder="DD/MM/YYYY" class="j_date" />
    </td>
    <th scope="row">Race<span class="must">*</span></th>
    <td>
    <select class="w100p" id="race" name="race">
       <c:forEach var="list" items="${race }" varStatus="status">
           <option value="${list.detailcodeid}">${list.detailcodename}</option>
        </c:forEach>
    </select>
    </td>
</tr>
<tr>
    <th scope="row">Nationality<span class="must">*</span></th>
    <td>
    <select class="w100p" id="nation" name="nation">
        <c:forEach var="list" items="${nationality }" varStatus="status">
           <option value="${list.countryid}">${list.name}</option>
        </c:forEach>
    </select>
    </td>
    <th scope="row">NRIC (New)<span class="must">*</span></th>
    <td>
    <input type="text" title="" placeholder="NRIC (New)" id="nric" name="nric" class="w100p" />
    </td>
    <th scope="row">Marrital Status<span class="must">*</span></th>
    <td>
    <select class="w100p" id="marrital" name="marrital">
         <c:forEach var="list" items="${marrital }" varStatus="status">
           <option value="${list.detailcodeid}">${list.detailcodename}</option>
        </c:forEach>
    </select>
    </td>
</tr>
<tr>
    <th scope="row" rowspan="3">Address<span class="must">*</span></th>
    <td colspan="5">
    <input type="text" title="" placeholder="Address(1)" class="w100p" id="address1" name="address1"/>
    </td>
</tr>
<tr>
    <td colspan="5">
    <input type="text" title="" placeholder="Address(2)" class="w100p" id="address2" name="address2"/>
    </td>
</tr>
<tr>
    <td colspan="5">
    <input type="text" title="" placeholder="Address(3)" class="w100p" id="address3" name="address3"/>
    </td>
</tr>
<tr>
    <th scope="row">Country<span class="must">*</span></th>
    <td>
    <select class="w100p" id="country" name="country">
        <c:forEach var="list" items="${nationality }" varStatus="status">
           <option value="${list.countryid}">${list.name}</option>
        </c:forEach>
    </select>
    </td>
    <th scope="row">State<span class="must">*</span></th>
    <td>
    <select class="w100p" id="state" name="state">
        <c:forEach var="list" items="${state }" varStatus="status">
           <option value="${list.codeId}">${list.codeName}</option>
        </c:forEach>
    </select>
    </td>
    <th scope="row">Area<span class="must">*</span></th>
    <td>
    <select class="w100p" id="area" name="area">
        
    </select>
    </td>
</tr>
<tr>
    <th scope="row">Postcode<span class="must">*</span></th>
    <td>
    <select class="w100p" id="postCode" name="postCode">
        <option value="">11</option>
        <option value="">22</option>
        <option value="">33</option>
    </select>
    </td>
    <th scope="row">Email</th>
    <td colspan="3">
    <input type="text" title="" placeholder="Email" class="w100p" id="email" name="email"/>
    </td>
</tr>
<tr>
    <th scope="row">Mobile No.</th>
    <td>
    <input type="text" title="" placeholder="Numberic Only" class="w100p" id="mobileNo" name="mobileNo"/>
    </td>
    <th scope="row">Office No.</th>
    <td>
    <input type="text" title="" placeholder="Numberic Only" class="w100p"  id="officeNo" name="officeNo"/>
    </td>
    <th scope="row">Residence No.</th>
    <td>
    <input type="text" title="" placeholder="Numberic Only" class="w100p" id="residenceNo"  name="residenceNo"/>
    </td>
</tr>
<tr>
    <th scope="row">Sponsor's Code</th>
    <td>

    <div class="search_100p"><!-- search_100p start -->
    <input type="text" title="" placeholder="Sponsor's Code" class="w100p" id="sponsorCd" name="sponsorCd"/>
    <a href="#" class="search_btn"><img src="../images/common/normal_search.gif" alt="search" /></a>
    </div><!-- search_100p end -->

    </td>
    <th scope="row">Sponsor's Name</th>
    <td>
    <input type="text" title="" placeholder="Sponsor's Name" class="w100p"  id="sponsorNm" name="sponsorNm"/>
    </td>
    <th scope="row">Sponsor's NRIC</th>
    <td>
    <input type="text" title="" placeholder="Sponsor's NRIC" class="w100p" id="sponsorNric" name="sponsorNric"/>
    </td>
</tr>
<tr>
    <th scope="row">Department Code<span class="must">*</span></th>
    <td>
    <select class="w100p" id="deptCd" name="deptCd">
        <option value="CRS3221">11</option>
        <option value="">22</option>
        <option value="">33</option>
    </select>
    </td>
    <th scope="row">Branch<span class="must">*</span></th>
    <td>
    <select class="w100p disabled" id="branch" name="branch">
        <option value="">11</option>
        <option value="">22</option>
        <option value="">33</option>
    </select>
    </td>
    <th scope="row">Transport Code<span class="must">*</span></th>
    <td>
    <select class="w100p disabled"  id="transportCd" name="transportCd">
        <option value="">11</option>
        <option value="">22</option>
        <option value="">33</option>
    </select>
    </td>
</tr>
<tr>
    <th scope="row">e-Approval Status</th>
    <td colspan="5">
    <input type="text" title="" placeholder="e-Approval Status" class="w100p" id="approval" name="approval" />
    </td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h2>Bank Account Information</h2>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:180px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Issued Bank<span class="must">*</span></th>
    <td>
    <select class="w100p" id="issuedBank" name="issuedBank">
      <c:forEach var="list" items="${issuedBank }" varStatus="status">
           <option value="${list.bankId}">${list.c1}</option>
       </c:forEach>
    </select>
    </td>
    <th scope="row">Bank Account No<span class="must">*</span></th>
    <td>
    <input type="text" title="" placeholder="Bank Account No" class="w100p" id="bankAccNo"  name="bankAccNo"/>
    </td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h2>Language Proficiency</h2>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:180px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Education Level</th>
    <td>
    <select class="w100p" id="educationLvl" name="educationLvl">
        <c:forEach var="list" items="${educationLvl }" varStatus="status">
           <option value="${list.detailcodeid}">${list.detailcodename}</option>
        </c:forEach>
    </select>
    </td>
    <th scope="row">Language</th>
    <td>
    <select class="w100p" id="language" name="language">
        <c:forEach var="list" items="${language }" varStatus="status">
           <option value="${list.detailcodeid}">${list.detailcodename}</option>
        </c:forEach>
    </select>
    </td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h2>First TR Consign</h2>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">TR No.</th>
    <td>
    <input type="text" title="" placeholder="TR No." class="w100p" id="trNo" name="trNo"/>
    </td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h2>Agreedment</h2>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Cody PA Expiry<span class="must">*</span></th>
    <td>
    <input type="text" title="" placeholder="DD/MM/YYYY" class="j_date" id="codyPaExpr" name="codyPaExpr"/>
    </td>
</tr>
</tbody>
</table><!-- table end -->

<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#" onClick="javascript:fn_memberSave()">SAVE</a></p></li>
    <li><p class="btn_blue2 big"><a href="#">CANCEL</a></p></li>
</ul>

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:120px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:180px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">MCode</th>
    <td>
    <input type="text" title="" placeholder="MCode" class="w100p" id="spouseCode" name="spouseCode" />
    </td>
    <th scope="row">Spouse Name</th>
    <td>
    <input type="text" title="" placeholder="Spouse Nam" class="w100p" id="spouseName" name="spouseName"/>
    </td>
    <th scope="row">NRIC / Passport No.</th>
    <td>
    <input type="text" title="" placeholder="NRIC / Passport No." class="w100p" id="spouseNRIC" name="spouseNRIC"/>
    </td>
</tr>
<tr>
    <th scope="row">Occupation</th>
    <td>
    <input type="text" title="" placeholder="Occupation" class="w100p" id="spouseOcc" name="spouseOcc"/>
    </td>
    <th scope="row">Date of Birth</th>
    <td>
    <input type="text" title="" placeholder="DD/MM/YYYY" class="j_date" id="spouseDOB" name="spouseDOB" />
    </td>
    <th scope="row">Contact No.</th>
    <td>
    <input type="text" title="" placeholder="Contact No. (Numberic Only)" class="w100p" id="spouseContat" name="spouseContat" />
    </td>
</tr>
</tbody>
</table><!-- table end -->

<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#">SAVE</a></p></li>
    <li><p class="btn_blue2 big"><a href="#">CANCEL</a></p></li>
</ul>

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->
<div id="grid_wrap_doc" style="width: 100%; height: 500px; margin: 0 auto;"></div>
</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<article class="grid_wrap"><!-- grid_wrap start -->
그리드 영역
</article><!-- grid_wrap end -->

<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#">SAVE</a></p></li>
    <li><p class="btn_blue2 big"><a href="#">CANCEL</a></p></li>
</ul>

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<article class="grid_wrap"><!-- grid_wrap start -->
그리드 영역
</article><!-- grid_wrap end -->

<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#">SAVE</a></p></li>
    <li><p class="btn_blue2 big"><a href="#">CANCEL</a></p></li>
</ul>
</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<article class="grid_wrap"><!-- grid_wrap start -->
그리드 영역
</article><!-- grid_wrap end -->

<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#">SAVE</a></p></li>
    <li><p class="btn_blue2 big"><a href="#">CANCEL</a></p></li>
</ul>
</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<article class="grid_wrap"><!-- grid_wrap start -->
그리드 영역
</article><!-- grid_wrap end -->

<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#">SAVE</a></p></li>
    <li><p class="btn_blue2 big"><a href="#">CANCEL</a></p></li>
</ul>
</article><!-- tap_area end -->

</section><!-- tap_wrap end -->
</form>
</section><!-- pop_body end -->

</div><!-- popup_wrap end -->
</body>
</html>