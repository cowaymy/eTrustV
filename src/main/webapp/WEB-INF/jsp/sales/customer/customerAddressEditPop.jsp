<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javascript">

//AUIGrid 생성 후 반환 ID
var addrGridID; // address list

$(document).ready(function(){
	/*  Gird */
	//AUIGrid 그리드를 생성합니다. (address, contact , bank, creditcard, ownorder, thirdparty )
	createAddrGrid();
	fn_getCustomerAddressAjax(); // address list
	
	/* Move Page */
    $("#_editCustomerInfo").change(function(){
          
        var stateVal = $(this).val();
        $("#_selectParam").val(stateVal);
        
    });
    
    $("#_confirm").click(function (currPage) {
    	fn_comboAuthCtrl();
    });
	
    // 셀 더블클릭 이벤트 바인딩
    AUIGrid.bind(addrGridID, "cellDoubleClick", function(event){
        $("#_editCustId").val(event.item.custId);
        $("#_editCustAddId").val(event.item.custAddId);
        Common.popupDiv('/sales/customer/updateCustomerAddressInfoPop.do', $("#editForm").serializeJSON(), null , true ,'_editDiv2Pop');
    }); 
    
    $("#_newAddr").click(function() {
		
    	Common.popupDiv('/sales/customer/updateCustomerNewAddressPop.do', $("#popForm").serializeJSON(), null , true ,'_editDiv2New');
    	
	});
});// Document Ready End
	
	function createAddrGrid(){
	
		var addrColumnLayout = [ {
	        dataField : "name",
	        headerText : "<spring:message code="sal.title.status" />",
	        width : '10%'
	    },{
            dataField : "areaChk",
            headerText : "<spring:message code="sal.title.isNew" />",
            width : '10%'
        }, {
	        dataField : "addr",
	        headerText : "<spring:message code="sal.title.address" />",
	        width : '70%'
	    }, {
	        dataField : "custAddId",
	        visible : false
	    },{
	        dataField : 'custId',
	        visible : false
	    },{
            dataField : 'areaId',
            visible : false
        },{
	        dataField : 'stusCodeId',
	        visible : false
	    },{ 
	        dataField : "setMain", 
	        headerText : "<spring:message code="sal.title.setAsMain" />", 
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
		
		//그리드 속성 설정
        var gridPros = {
                
                usePaging           : true,         //페이징 사용
                pageRowCount        : 10,           //한 화면에 출력되는 행 개수 20(기본값:20)            
                editable            : false,            
                fixedColumnCount    : 1,            
                showStateColumn     : true,             
                displayTreeOpen     : false,            
     //           selectionMode       : "singleRow",  //"multipleCells",            
                headerHeight        : 30,       
                useGroupingPanel    : false,        //그룹핑 패널 사용
                skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
                wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
                showRowNumColumn    : true,         //줄번호 칼럼 렌더러 출력    
                noDataMessage       : "No order found.",
                groupingMessage     : "Here groupping"
            };
		
        addrGridID = GridCommon.createAUIGrid("#address_grid_wrap", addrColumnLayout,'', gridPros);  // address list
	
    }
	
	// Get address by Ajax
	function fn_getCustomerAddressAjax() {        
	    Common.ajax("GET", "/sales/customer/selectCustomerAddressJsonList",$("#popForm").serialize(), function(result) {
	        AUIGrid.setGridData(addrGridID, result);
	    });
	}
	
	// Popup Option     
    var option = {
    		
			location : "no", // 주소창이 활성화. (yes/no)(default : yes)
            width : "1200px", // 창 가로 크기
            height : "400px" // 창 세로 크기
    };
	
	// set Main Func (Confirm)
	function fn_setMain(custAddId, custId){ 
		$("#tempCustId").val(custId);
        $("#tempCustAddr").val(custAddId);	
        Common.confirm("Are you sure want to set this address as main address ?", fn_changeMainAddr, fn_reloadPage);
		
	}
	
	//call Ajax(Set Main Address)
	function fn_changeMainAddr(){
		$("#_custId").val($("#tempCustId").val());
        $("#_custAddId").val($("#tempCustAddr").val()); 
		Common.ajax("GET", "/sales/customer/updateCustomerAddressSetMain.do", $("#popForm").serialize(), function(result){
			//result alert and reload
			Common.alert(result.message, fn_reloadPage);
		});
	}
	
	function fn_reloadPage(){
		//Parent Window Method Call
		fn_selectPstRequestDOListAjax();
		$("#_selectParam").val('2');
		Common.popupDiv('/sales/customer/updateCustomerAddressPop.do', $('#popForm').serializeJSON(), null , true, '_editDiv2');
        $("#_close").click();
	}
	
	//close Func
    function fn_closeFunc(){
    	 $("#_selectParam").val('1');
    }
</script>
<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->
<input type="hidden" id="tempCustId">
<input type="hidden" id="tempCustAddr">
<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="sal.page.title.custAddrMaintenance" /></h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#" id="_close" onclick="javascript: fn_closeFunc()" ><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->
<!-- move Page & set Main Address Form  -->
<!-- move Page Form  -->
<section class="pop_body"><!-- pop_body start -->
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.text.editType" /></th>
    <td>
     <select id="_editCustomerInfo">
        <option value="1" <c:if test="${selectParam eq 1}">selected</c:if>><spring:message code="sal.combo.text.editBasicInfo" /></option>
        <option value="2" <c:if test="${selectParam eq 2}">selected</c:if>><spring:message code="sal.combo.text.editCustAddr" /></option>
        <option value="3" <c:if test="${selectParam eq 3}">selected</c:if>><spring:message code="sal.combo.text.editContactInfo" /></option>
        <option value="4" <c:if test="${selectParam eq 4}">selected</c:if>><spring:message code="sal.combo.text.editBankAcc" /></option>
        <option value="5" <c:if test="${selectParam eq 5}">selected</c:if>><spring:message code="sal.combo.text.editCreditCard" /></option>
        <option value="6" <c:if test="${selectParam eq 6}">selected</c:if>><spring:message code="sal.combo.text.editBasicInfoLimit" /></option>
    </select>
    <p class="btn_sky"><a href="#" id="_confirm"><spring:message code="sal.btn.confirm" /></a></p>
    </td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h2><spring:message code="sal.page.title.custInformation" /></h2>
</aside><!-- title_line end -->

<section class="tap_wrap mt10"><!-- tap_wrap start -->
<ul class="tap_type1">
    <li><a href="#" class="on"><spring:message code="sal.tap.title.basicInfo" /></a></li>
    <li><a href="#"><spring:message code="sal.tap.title.mainAddr" /></a></li>
    <li><a href="#"><spring:message code="sal.tap.title.mainContact" /></a></li>
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
    <th scope="row"><spring:message code="sal.text.customerId" /></th>
    <td><span>${result.custId}</span></td>
    <th scope="row"><spring:message code="sal.text.custType" /></th>
    <td>
        <span> 
                ${result.codeName1}
                <!-- not Individual -->  
                <c:if test="${ result.typeId ne 964}">
                    (${result.codeName})
                </c:if>
            </span>
    </td>
    <th scope="row"><spring:message code="sal.text.createAt" /></th>
    <td>${result.crtDt}</td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.custName" /></th>
    <td colspan="3">${result.name}</td>
    <th scope="row"><spring:message code="sal.text.createBy" /></th>
    <td>
        <c:if test="${result.crtUserId ne 0}">
                ${result.userName}
            </c:if>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.nricCompanyNum" /></th>
    <td><span>${result.nric}</span></td>
    <th scope="row"><spring:message code="sal.text.gstRegistrationNo" /></th>
    <td>${result.gstRgistNo}</td>
    <th scope="row"><spring:message code="sal.text.updateBy" /></th>
    <td>${result.userName1}</td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.email" /></th>
    <td><span>${result.email}</span></td>
    <th scope="row"><spring:message code="sal.text.nationality" /></th>
    <td>${result.cntyName}</td>
    <th scope="row"><spring:message code="sal.text.updateAt" /></th>
    <td>${result.updDt}</td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.gender" /></th>
    <td><span>${result.gender}</span></td>
    <th scope="row"><spring:message code="sal.text.dob" /></th>
    <td>
        <c:if test="${result.dob ne '01-01-1900'}">
                ${result.dob}
        </c:if>
    </td>
    <th scope="row"><spring:message code="sal.text.race" /></th>
    <td>${result.codeName2 }</td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.passportExpire" /></th>
    <td><span>${result.pasSportExpr}</span></td>
    <th scope="row"><spring:message code="sal.text.visaExpire" /></th>
    <td>${result.visaExpr}</td>
    <th scope="row"><spring:message code="sal.text.vaNumber" /></th>
    <td>${result.custVaNo}</td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.remark" /></th>
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
    <th scope="row"><spring:message code="sal.text.fullAddr" /></th>
    <td>
        <span>${addresinfo.fullAddress}</span>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.remark" /></th>
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
    <th scope="row"><spring:message code="sal.text.name" /></th>
    <td><span>${contactinfo.name1}</span></td>
    <th scope="row"><spring:message code="sal.text.initial" /></th>
    <td><span>${contactinfo.code}</span></td>
    <th scope="row"><spring:message code="sal.text.gender" /></th>
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
    <th scope="row"><spring:message code="sal.text.nric" /></th>
    <td><span>${contactinfo.nric}</span></td>
    <th scope="row"><spring:message code="sal.text.dob" /></th>
    <td>
        <span>
            <c:if test="${contactinfo.dob ne  '01-01-1900'}">
                ${contactinfo.dob}
            </c:if> 
        </span>
    </td>
    <th scope="row"><spring:message code="sal.text.race" /></th>
    <td><span>${contactinfo.codeName}</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.email" /></th>
    <td><span>${contactinfo.email}</span></td>
    <th scope="row"><spring:message code="sal.text.dept" /></th>
    <td><span>${contactinfo.dept}</span></td>
    <th scope="row"><spring:message code="sal.text.post" /></th>
    <td><span>${contactinfo.pos}</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.telM" /></th>
    <td><span>${contactinfo.telM1}</span></td>
    <th scope="row"><spring:message code="sal.text.telR" /></th>
    <td><span>${contactinfo.telR}</span></td>
    <th scope="row"><spring:message code="sal.text.telO" /></th>
    <td><span>${contactinfo.telO}</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.telF" /></th>
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
    <li><p class="btn_grid"><a href="#" id="_newAddr"><spring:message code="sal.btn.addNewAddr" /></a></p></li>
</ul>
<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="address_grid_wrap" style="width:100%; height:480px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->
<!-- ########## Address Grid End ########## -->
</section><!-- pop_body end -->
</div>