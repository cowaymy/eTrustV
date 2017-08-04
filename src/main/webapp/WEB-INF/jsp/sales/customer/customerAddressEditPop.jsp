<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javascript">

//AUIGrid 생성 후 반환 ID
var addrGridID; // address list

$(document).ready(function(){
	
	/* Move Page */
    $("#_editCustomerInfo").change(function(){
          
        var stateVal = $(this).val();
        $("#_selectParam").val(stateVal);
        
    });
    
    $("#_confirm").click(function () {
        
        var status = $("#_selectParam").val();
        
        if(status == '1'){
            $("#editForm").attr({"target" :"_self" , "action" : "/sales/customer/updateCustomerBasicInfoPop.do" }).submit();
        }
        if(status == '2'){
            $("#editForm").attr({"target" :"_self" , "action" : "/sales/customer/updateCustomerAddressPop.do" }).submit();
        }
        if(status == '3'){
            $("#editForm").attr({"target" :"_self" , "action" : "/sales/customer/updateCustomerContactPop.do" }).submit();
        }
        if(status == '4'){
            $("#editForm").attr({"target" :"_self" , "action" : "/sales/customer/updateCustomerBankAccountPop.do" }).submit();
        }
        if(status == '5'){
            $("#editForm").attr({"target" :"_self" , "action" : "/sales/customer/updateCustomerCreditCardPop.do" }).submit();
        }
        if(status == '6'){
            $("#editForm").attr({"target" :"_self" , "action" : "/sales/customer/updateCustomerBasicInfoLimitPop.do" }).submit();
        }
    }); 
	
    /*  Gird */
	//AUIGrid 그리드를 생성합니다. (address, contact , bank, creditcard, ownorder, thirdparty )
	addrGridID = GridCommon.createAUIGrid("#address_grid_wrap", addrColumnLayout,'', gridPros);  // address list
	fn_getCustomerAddressAjax(); // address list
	
    // 셀 더블클릭 이벤트 바인딩
    AUIGrid.bind(addrGridID, "cellDoubleClick", function(event){
        $("#custId").val(event.item.custId);
        $("#custAddId").val(event.item.custAddId);
        
        Common.popupWin("editForm", "/sales/customer/updateCustomerAddressInfoPop.do", option);
    }); 
});// Document Ready End
	
	// Get address by Ajax
	function fn_getCustomerAddressAjax() {        
	    Common.ajax("GET", "/sales/customer/selectCustomerAddressJsonList",$("#editForm").serialize(), function(result) {
	        AUIGrid.setGridData(addrGridID, result);
	    });
	}
	
	//그리드 속성 설정
	var gridPros = {

		// 페이징 사용       
		usePaging : true,
		// 한 화면에 출력되는 행 개수 10(기본값:10)
		pageRowCount : 10,
		// 수정 
		editable : false,
		// column Count
		fixedColumnCount : 1,
		
		showStateColumn : false, //true
		
		displayTreeOpen : false, //true
		
		selectionMode : "multipleCells",
		
		headerHeight : 30,
		// 그룹핑 패널 사용
		useGroupingPanel : false, //true
		// 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
		skipReadonlyColumns : true,
		// 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
		wrapSelectionMove : false, //false
		// 줄번호 칼럼 렌더러 출력
		showRowNumColumn : false,
		
		groupingMessage : "Here groupping"		
	};

	var addrColumnLayout = [ {
		dataField : "name",
		headerText : "Status",
		width : '10%'
	}, {
		dataField : "addr",
		headerText : "Address",
		width : '80%'
	}, {
		dataField : "custAddId",
		visible : false
	},{
		dataField : 'custId',
		visible : false
	},{
		dataField : 'stusCodeId',
		visible : false
	},{ 
        dataField : "setMain", 
        headerText : "Set As Main", 
        width:'10%', 
        renderer : { 
            type : "TemplateRenderer", 
            editable : true // 체크박스 편집 활성화 여부(기본값 : false)
        }, 
        // dataField 로 정의된 필드 값이 HTML 이라면 labelFunction 으로 처리할 필요 없음. 
        labelFunction : function (rowIndex, columnIndex, value, headerText, item ) { // HTML 템플릿 작성 
        	var html = '';
        
            html += '<label><input type="radio" name="setmain"  onclick="javascript: fn_setMain(' + item.custAddId + ','+item.custId+')"';
            
            if(item.stusCodeId == 9){
            	html+= ' checked = "checked"';
            	html+= ' disabled = "disabled"';
            }
            
            html += '/></label>'; 
            
            return html;
        } 
        
      }];
	
	// Popup Option     
    var option = {
    		
			location : "no", // 주소창이 활성화. (yes/no)(default : yes)
            width : "1200px", // 창 가로 크기
            height : "400px" // 창 세로 크기
    };
	
	// set Main Func (Confirm)
	function fn_setMain(custAddId, custId){ //sys.common.alert.save // <spring:message code='sys.common.alert.save'/>
		$("#custId").val(custId);
        $("#custAddId").val(custAddId);	
        Common.confirm("Are you sure want to set this address as main address ?", fn_changeMainAddr, fn_reloadPage);
		/*
		    1. Are you sure want to set this address as main address ?
		    2. <spring:message code='sys.common.alert.save'/>		
		*/
	}
	
	//call Ajax(Set Main Address)
	function fn_changeMainAddr(){
		
		Common.ajax("GET", "/sales/customer/updateCustomerAddressSetMain.do", $("#editForm").serialize(), function(result){
			//result alert and reload
			Common.alert(result.message, fn_reloadPage);
		});
	}
	
	function fn_reloadPage(){
		//Parent Window Method Call
		window.opener.parent.fn_selectPstRequestDOListAjax();
		$("#editForm").attr({"target" :"_self" , "action" : "/sales/customer/updateCustomerAddressPop.do" }).submit();
	}
	
</script>
<!-- move Page & set Main Address Form  -->
<form id="editForm">
    <input type="hidden" name="custId" value="${custId}" id="custId"/>
    <input type="hidden" name="custAddId" value="${custAddId}" id="custAddId"/>
    <input type="hidden" name="custCntcId" value="${custCntcId}" id="custCntcId"> 
    <input type="hidden" name="selectParam"  id="_selectParam" value="${selectParam}"/>
</form>
<section class="pop_body"><!-- pop_body start -->
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">EDIT Type</th>
    <td>
     <select id="_editCustomerInfo">
        <option value="1" <c:if test="${selectParam eq 1}">selected</c:if>>Edit Basic Info</option>
        <option value="2" <c:if test="${selectParam eq 2}">selected</c:if>>Edit Customer Address</option>
        <option value="3" <c:if test="${selectParam eq 3}">selected</c:if>>Edit Contact Info</option>
        <option value="4" <c:if test="${selectParam eq 4}">selected</c:if>>Edit Bank Account</option>
        <option value="5" <c:if test="${selectParam eq 5}">selected</c:if>>Edit Credit Card</option>
    </select>
    <p class="btn_sky"><a href="#" id="_confirm">Confirm</a></p>
    </td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h2>Customer Information</h2>
</aside><!-- title_line end -->

<section class="tap_wrap mt10"><!-- tap_wrap start -->
<ul class="tap_type1">
    <li><a href="#" class="on">Basic Info</a></li>
    <li><a href="#">Main Address</a></li>
    <li><a href="#">Main Contact</a></li>
</ul>

<article class="tap_area"><!-- tap_area start -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:140px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:120px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Customer ID</th>
    <td><span>${result.custId}</span></td>
    <th scope="row">Customer Type</th>
    <td>
        <span> 
                ${result.codeName1}
                <!-- not Individual -->  
                <c:if test="${ result.typeId ne 964}">
                    (${result.codeName})
                </c:if>
            </span>
    </td>
    <th scope="row">Create At</th>
    <td>${result.crtDt}</td>
</tr>
<tr>
    <th scope="row">Customer Name</th>
    <td colspan="3">${result.name}</td>
    <th scope="row">Create By</th>
    <td>
        <c:if test="${result.crtUserId ne 0}">
                ${result.crtUserId}
            </c:if>
    </td>
</tr>
<tr>
    <th scope="row">NRIC/Company Number</th>
    <td><span>${result.nric}</span></td>
    <th scope="row">GST Registration No</th>
    <td>${result.gstRgistNo}</td>
    <th scope="row">Update By</th>
    <td>${result.userName1}</td>
</tr>
<tr>
    <th scope="row">Email</th>
    <td><span>${result.email}</span></td>
    <th scope="row">Nationality</th>
    <td>${result.cntyName}</td>
    <th scope="row">Update At</th>
    <td>${result.updDt}</td>
</tr>
<tr>
    <th scope="row">Gender</th>
    <td><span>${result.gender}</span></td>
    <th scope="row">DOB</th>
    <td>
        <c:if test="${result.dob ne '01-01-1900'}">
                ${result.dob}
        </c:if>
    </td>
    <th scope="row">Race</th>
    <td>${result.codeName2 }</td>
</tr>
<tr>
    <th scope="row">Passport Expire</th>
    <td><span>${result.pasSportExpr}</span></td>
    <th scope="row">Visa Expire</th>
    <td>${result.visaExpr}</td>
    <th scope="row">VA Number</th>
    <td>${result.custVaNo}</td>
</tr>
<tr>
    <th scope="row">Remark</th>
    <td colspan="5"><span>${result.rem}</span></td>
</tr>
</tbody>
</table><!-- table end -->
</article><!-- tap_area end -->
<!-- ######### main address info ######### -->
<article class="tap_area"><!-- tap_area start -->
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:130px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Full Address</th>
    <td>
        <span>
                ${addresinfo.add1}&nbsp;${addresinfo.add2}&nbsp;${addresinfo.add3}&nbsp;
                ${addresinfo.postCode}&nbsp;${addresinfo.areaName}&nbsp;${addresinfo.name1}&nbsp;${addresinfo.name2}
        </span>
    </td>
</tr>
<tr>
    <th scope="row">Remark</th>
    <td>${addresinfo.rem}</td>
</tr>
</tbody>
</table><!-- table end -->
</article><!-- tap_area end -->

<!-- ######### main Contact info ######### -->
<article class="tap_area"><!-- tap_area start -->
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:120px" />
    <col style="width:*" />
    <col style="width:140px" />
    <col style="width:*" />
    <col style="width:120px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Name</th>
    <td><span>${contactinfo.name1}</span></td>
    <th scope="row">Initial</th>
    <td><span>${contactinfo.code}</span></td>
    <th scope="row">Genders</th>
    <td>
            <c:choose >
                <c:when test="${contactinfo.gender eq 'M'}">
                     Male
                </c:when>
                <c:when test="${contactinfo.gender eq 'F'}">
                     Female
                </c:when>
                <c:otherwise>
                    <!-- korean : 5  -->                    
                </c:otherwise>
            </c:choose>
     </td>
</tr>
<tr>
    <th scope="row">NRIC</th>
    <td><span>${contactinfo.nric}</span></td>
    <th scope="row">DOB</th>
    <td>
        <span>
            <c:if test="${contactinfo.dob ne  '01-01-1900'}">
                ${contactinfo.dob}
            </c:if> 
        </span>
    </td>
    <th scope="row">Race</th>
    <td><span>${contactinfo.codeName}</span></td>
</tr>
<tr>
    <th scope="row">Email</th>
    <td><span>${contactinfo.email}</span></td>
    <th scope="row">Department</th>
    <td><span>${contactinfo.dept}</span></td>
    <th scope="row">Post</th>
    <td><span>${contactinfo.pos}</span></td>
</tr>
<tr>
    <th scope="row">Tel (Mobile)</th>
    <td><span>${contactinfo.telM1}</span></td>
    <th scope="row">Tel (Residence)</th>
    <td><span>${contactinfo.telR}</span></td>
    <th scope="row">Tel (Office)</th>
    <td><span>${contactinfo.telO}</span></td>
</tr>
<tr>
    <th scope="row">Tel (Fax)</th>
    <td>${contactinfo.telf}</td>
    <th scope="row"></th>
    <td></td>
    <th scope="row"></th>
    <td></td>
</tr>
</tbody>
</table><!-- table end -->
</article><!-- tap_area end -->
</section><!-- tap_wrap end -->
<!-- ########## Basic Info End ##########  -->
<!-- ########## Address Grid Start ########## -->
<ul class="right_btns">
    <li><p class="btn_grid"><a href="#">ADD New Address</a></p></li>
</ul>
<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="address_grid_wrap" style="width:100%; height:480px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->
<!-- ########## Address Grid End ########## -->
</section><!-- pop_body end -->