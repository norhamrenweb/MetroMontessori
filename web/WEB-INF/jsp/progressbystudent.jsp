<%-- 
    Document   : createlesson
    Created on : 30-ene-2017, 14:59:17
    Author     : nmohamed
--%>


<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<!DOCTYPE html>
<html>
    <%@ include file="infouser.jsp" %>
    <%@ include file="menu.jsp" %>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title><spring:message code="etiq.students"/></title>
        <script>



            var pestaña = "";
            var userType = ${user.type};
            $(document).ready(function () {


                //$("#commentLength").text($("#commentSubject").val().length);


                /* <div class="col-xs-7" id="divTerms" style="display: flex;justify-content: space-evenly;">
                 <div class="form-check">
                 <input class="form-check-input" name="exampleRadios" id="exampleRadios1" value="option1" type="radio">
                 <label class="form-check-label" for="exampleRadios1">Term1</label>
                 </div>
                 <div class="form-check">
                 <input class="form-check-input" name="exampleRadios" id="exampleRadios2" value="option2" type="radio">
                 <label class="form-check-label" for="exampleRadios2">Term2</label>
                 </div>
                 <div class="form-check">
                 <input class="form-check-input" name="exampleRadios" id="exampleRadios1" value="option1" type="radio">
                 <label class="form-check-label" for="exampleRadios1">Term3</label>
                 </div>
                 <div class="form-check">
                 <input class="form-check-input" name="exampleRadios" id="exampleRadios2" value="option2" type="radio">
                 <label class="form-check-label" for="exampleRadios2">Term4</label>
                 </div>
                 <div class="form-check">
                 <input class="form-check-input" name="exampleRadios" id="exampleRadios1" value="option1" checked="" type="radio">
                 <label class="form-check-label" for="exampleRadios1">All</label>
                 </div>
                 </div>*/


                $("#saveSupervisorComment").hide();
                $("#TXTsupervisorComment").prop("disabled", true);
                //VARIABLE CUANDO HEMOS CREADO UNA LESSONS CORRECTAMENTE
                if (userType === 2) {
                    $("#saveSupervisorComment").show();
                    $("#TXTsupervisorComment").prop("disabled", false);
                }
                $("#tg").treegrid();
                $("#saveCommentSubjectButton").prop('disabled', true);
                $("#commentSubject").hide();
                $("#commentLength").hide();
                $('#tableobjective').DataTable();
                table = $('#table_students').DataTable(
                        {
                            language: idioma,
                            "searching": true,
                            "paging": false,
                            "ordering": false,
                            "info": false,
                            columns: [
                                {data: 'id',
                                    visible: false},
                                {data: 'name'}
                            ]
                        });
                $('#myTab ul li').on('click', function () {
                    pestaña = $(this).text();
                });


                $('#collapseTree').on('click', function () {
                    $("#tg").treegrid('collapseAll');
                });

                $('#table_students tbody').on('click', 'tr', function () {

                    data = table.row(this).data();
                    data1 = data.id;
                    //  $('#arbol').tab('show');
                    selectionStudent();
                    $('#divProgress').removeClass("hidden");
                    $('#savecomment').prop("disabled", true);
                });
                var today = new Date();
                $('#fecha').datetimepicker({
                    format: 'YYYY-MM-DD',
//            locale: userLang.valueOf(),
                    daysOfWeekDisabled: [0, 6],
                    maxDate: today,
                    useCurrent: false//Important! See issue #1075
                            //defaultDate: '08:32:33',


                });
                $('#fecha').on('dp.change', function (e) {
                    if (($('#observationfecha').val() !== "") && ($('#observationcomments').val() !== "") && ($('#observationtype').val() !== "")) {
                        $('#savecomment').prop("disabled", false);
                    } else {
                        $('#savecomment').prop("disabled", true);
                    }
                });
                $('#commentSubject').keyup(function (e) {
                    $("#commentLength").text($("#commentSubject").val().length);
                });

                $('#observationcomments,#observationtype').change(function () {
                    if (($('#observationfecha').val() !== "") && ($('#observationcomments').val() !== "") && ($('#observationtype').val() !== "")) {
                        $('#savecomment').prop("disabled", false);
                    } else {
                        $('#savecomment').prop("disabled", true);
                    }
                });

                $(window).resize(function () {
                    $('#tg').datagrid("resize");

                });
//                $("#subjects").change(function () {
//                    if ($("#subjects :selected").text() === "Select Subject" || $("#subjects :selected").text() === "") {
//                        $("#saveCommentSubjectButton").prop('disabled', true);
//                        $("#commentSubject").val("");
//                    } else {
//                        $("#saveCommentSubjectButton").prop('disabled', false);
//
//                        var idSubjectX = $("#subjects :selected").val() + "$" + $("#studentid").val();
//                        $.ajax({
//                            type: 'POST',
//                            url: 'getSubjectComment.htm',
//                            data: idSubjectX,
//                            contentType: 'text/plain',
//                            success: function (data) {
//                                $("#commentSubject").val(data);
//
//                            },
//                            error: function (xhr, ajaxOptions, thrownError) {
//                                console.log(xhr.status);
//                                console.log(xhr.responseText);
//                                console.log(thrownError);
//                            }
//
//                        });
//                    }
//                });

                $("#fileToUpload").change(function () {

                    $(this).next().children().next().text($(this).val().split('/').pop().split('\\').pop());
                });
                
                $("#fileToUpload").mouseover(function () {

                    $("#fileToUpload").next().children().first().css("background-color", "#3074af")
                    $("#fileToUpload").next().children().first().css("color", "white")
                    $("#fileToUpload").next().children().first().css("border-color", "white")
                });
     
                $("#fileToUpload").mouseout(function () {
                   
                    $("#fileToUpload").next().children().first().css("background-color", "white")
                    $("#fileToUpload").next().children().first().css("color", "#3074af")
                    $("#fileToUpload").next().children().first().css("border-color", "#3074af")
                });

            });
            var ajax;
            var d = new Date();
            var month = d.getMonth() + 1;
            var day = d.getDate();
            var hour = d.getHours();
            var minute = d.getMinutes();
            var second = d.getSeconds();
            var currentTime = d.getFullYear() + '-' +
                    (('' + month).length < 2 ? '0' : '') + month + '-' +
                    (('' + day).length < 2 ? '0' : '') + day + ' ' +
                    (('' + hour).length < 2 ? '0' : '') + hour + ':'
                    + (('' + minute).length < 2 ? '0' : '') + minute;
//           + ':' + ((''+second).length<2 ? '0' :'') + second;



            function changeTermYear() {
                var year = $('#yearSelect option:selected').val();
                var term = $('#termSelect option:selected').val();
                var url = "<c:url value="/changeTermYear.htm"/>?yearid=" + year + "&termid=" + term;
                var nameYearAndTerm = $('#termSelect option:selected').text() + " / " + $('#yearSelect option:selected').text();
                $('#loadingmessage').show();
                $.ajax({
                    type: 'POST',
                    url: url,
                    contentType: "application/json",
                    success: function (data) {
                        $('#btnYearmTerm').text(nameYearAndTerm);
                        // alert("progress by student");
                        chargeDataStudent();

                    },
                    error: function (xhr, ajaxOptions, thrownError) {
                        console.log(xhr.status);
                        console.log(xhr.responseText);
                        console.log(thrownError);
                    }

                });
                $('#loadingmessage').hide();
            }
            function chargeDataStudent() {
                var idStudent = $("#studentid").val();
                var idSubjectAcademic = $("#subjects").val();
                
                if (idStudent !== undefined && idStudent !== "") {
//  ajax.open("POST", "studentPage.htm?selectStudent=" + selectStudent, true);
                    $.ajax({
                        type: 'POST',
                        url: 'studentPage.htm?selectStudent=' + idStudent,
                        contentType: "application/json",
                        success: function (data) {
                            var json = JSON.parse(data);
                            var info = JSON.parse(json.info);
                            var foto = JSON.parse(json.prueba);
                            var prog = JSON.parse(json.prog);
                            var subjects = JSON.parse(json.sub);
                            var nextPresentations = JSON.parse(json.nextPresentations);

                            $('#gradelevel').text(info.level_id);
                            $('#nextlevel').text(info.nextlevel);
                            $('#student').text(info.nombre_students);
                            $('#studentid').val(info.id_students);
                            $('#BOD').text(info.fecha_nacimiento);
                            $("#TXTsupervisorComment").val(json.commentHead);

                            $("#commentSubject").val("");
                            /* if (typeof info.foto === 'undefined' || info.foto === "") {
                             $('#foto').attr('src', '../recursos/img/NotPhoto.png');
                             } else {
                             $('#foto').removeAttr('src');
                             $('#foto').attr('src', foto);
                             }
                             */
                            $("#listObjectiveReport tbody").empty();
                            $('.cell').off('click');
                            //treeload(info.level_id, info.id_students);
                            ///  treeload2(prog);
                            levelarbol = info.level_id;
                            studentarbol = info.id_students;
                            //hide the objectives in case a previous student was selected
                            $('#divTableObjective').addClass('hidden'); //to avoid having the general comments of the previous selected student
                            $('#divNotObjective').addClass('hidden');
                            
        
                            $('#subjects').empty();
                            $('#subjects').append('<option>Select Subject</option>');
                            $.each(subjects, function (i, item) {
                                if (subjects[i].name !== undefined)
                                    $('#subjects').append('<option value= "' + subjects[i].id + '">' + subjects[i].name + '</option>');
                            });
                            sortSelect("subjects");


                            if($("#subjects option[value='"+idSubjectAcademic+"']").length > 0)
                                $('#subjects').val(idSubjectAcademic);
                            else
                                $('#subjects').val("-1");
                            
                            loadobjGeneralcomments();
                                                
        
                            $('#subjectsReports').empty();
                            $('#subjectsReports').append('<option value ="-1">Select Subject</option>');
                            $.each(subjects, function (i, item) {
                                if (subjects[i].name !== undefined)
                                    $('#subjectsReports').append('<option value= "' + subjects[i].id + '">' + subjects[i].name + '</option>');
                            });


                            sortSelect("subjectsReports");

                            $("#subjectsReports").val(-1)

                            $('#divCommentSubject').removeClass('hidden');
                            $('#saveCommentSubject>i').removeClass('glyphicon-chevron-up');
                            $('#saveCommentSubject>i').addClass('glyphicon-chevron-down');
                            $("#divTerms").empty();

                            $("#termSelect option").each(function () {
                                $("#divTerms").append("<div class='radio' style='margin-left: 5%;'><label><input  onclick='selectTreeByTerm(" + $(this).attr("value") + ")' type='radio' name='opt'" + $(this).attr("value") + "'>" + $(this).text() + "</label></div>");
                            });
                            $("#divTerms").append("<div class='radio' style='margin-left: 5%;'><label><input onclick='selectTreeByTerm(-1)' type='radio' name='opt' vlaue='all' checked>All</label></div>");

                            $("#nextPresentations").empty();
                            for (var i = 0; i < nextPresentations.length; i++) {
                                var html_Li = " <div class='col-xs-12 nextPresentation'>\n\
                                                <div class='col-xs-10'>" + nextPresentations[i].col2 + " </div>\n\
                                                <div class='col-xs-2> <span class='badgeGoglyphicon glyphicon-eye-open' title='Progress Presentation' onclick='rowselect(" + nextPresentations[i].col1 + ")'></span></div> \n\
                                            </div>";
                                $("#nextPresentations").append(html_Li);
                            }



                        },
                        error: function (xhr, ajaxOptions, thrownError) {
                            console.log(xhr.status);
                            console.log(xhr.responseText);
                            console.log(thrownError);
                        }

                    });
                }
               

            }
            function funcionCallBackloadGeneralcomments()
            {
                if (ajax.readyState === 4) {
                    if (ajax.status === 200) {
                        var json = JSON.parse(ajax.responseText);
                        var objs = JSON.parse(json.objs);
                        if (objs.length === 0) {
                            $('#divTableObjective').addClass('hidden');
                            $('#divNotObjective').removeClass('hidden');
                        } else {
                            $('#divNotObjective').addClass('hidden');
                            $('#divTableObjective').removeClass('hidden');
                        }
                        ;
                        $("#saveCommentSubjectButton").prop('disabled', false);
                        $("#commentSubject").show();
                        $("#commentLength").show();
                        $("#commentSubject").val(json.comment);
                        $("#commentLength").text($("#commentSubject").val().length);
                        $('#tableobjective').DataTable({
                            destroy: true,
                            paging: false,
                            searching: false,
                            ordering: false,
                            data: objs,
                            columns: [
                                {data: 'col1'},
                                {data: 'col2'},
                                {data: 'col3',
                                    defaultContent: ''},
                                {data: 'col4',
                                    defaultContent: ''
                                },
                                {data: 'col5'}
                            ],
                            columnDefs: [
                                {width: 90, targets: 0},
                                {width: 200, targets: 0},
                                {width: 200, targets: 0},
                                {width: 70, targets: 0},
                                {width: 100, targets: 0}
                            ]
                        });
                        //var tableObjective = $('#tableobjective').DataTable();

                        $.each(objs, function (i, item) {
                            var gComment = item.col3;
                            if (gComment === undefined)
                                gComment = "";
//                         var commentgeneral = $('#tableobjective tbody tr td:eq(2)').text();
//                            $('#tableobjective tbody tr:eq(' + i + ') td:eq(2)').empty();
//                            $('#tableobjective tbody tr:eq(' + i + ') td:eq(2)').append("<div class='input-group'>\n\
//                <textarea rows='2' class='form-control commentGeneral' id='comment" + item.col5 + "'>" + gComment + "</textarea>\n\
//<span class='input-group-btn'>\n\
//<button type='button' class='btn btn-default btn-xs' value='" + item.col5 + "' onclick='saveGeneralComment(" + item.col5 + ")'>save</button>\n\
//</span></div>");
//                        if(item.col4 === currentTime ){
//                        $('#tableobjective tbody tr:eq('+ i +') td:eq(3)').append("<div class='input-group'>"+currentTime+"</div>");
//                        }
                            $('#tableobjective tbody tr:eq(' + i + ') td:eq(4)').empty();
                            $('#tableobjective tbody tr:eq(' + i + ') td:eq(4)').append("<button type='button' class='btn-unbutton' value='" + item.col5 + "' onclick='selectionObjective(" + item.col5 + ")'>More details</button>");
                            //$('#tableobjective tbody tr:eq('+ i +') td:eq(4)').append("<button type='submit' class='btn-unbutton' value='"+item.col5+"'>More details</button>");
//                                 $('#tableobjective tbody tr:eq('+ i +') td:eq(4)').text("more details");
                        });
                        $('#tableobjective').DataTable().destroy();
                        $('#tableobjective').DataTable();
//                        var commentgeneral = $('#tableobjective tbody tr td:eq(2)').text();
//                        $('#tableobjective tbody tr td:eq(2)').empty();
//                        $('#tableobjective tbody tr td:eq(2)').append("<input value='"+commentgeneral+"'></input>");   


//     $('#tableobjective tbody tr td:eq(4)').on('click', 'tr', 'td:eq(4)', function () {
//        
//        var dataObjective = tableObjective.row( this ).data();
//        dataObjective1 = dataObjective['col5'];
//        selectionObjective();
//    } );                
                    }
                }
            }


//            function funcionCallBackSaveGeneralComent()
//            {
//                if (ajax.readyState === 4) {
//                    if (ajax.status === 200) {
//
//                        var json = JSON.parse(ajax.responseText);
//                        //console.log(json);
//                        var mensaje = json.message;
//                        if (mensaje === "Comment successfully updated") {
//                            $('#tableobjective tbody tr').find(':button.btn-xs[value="' + json.objectiveid + '"]').parent().parent().parent().siblings('td:eq(2)').text(currentTime);
//                            $('#showModalComment').click();
//                            $('#titleComment').text(mensaje);
//
//                        } else {
//                            $('#showModalComment').click();
//                            $('#titleComment').text(mensaje);
//                        }
//                    }
//                }
//            }

            var levelarbol;
            var studentarbol;
            function treeload2(prog) {
                var pActual = $("ul li.active").text().replace(" ", "");
                $('#Objectivestracking').tab('show');
                $('#tg').empty();
                $('#tg').treegrid({
                    data: prog.children,
                    idField: 'id',
                    treeField: 'name',
                    fitColumns: true,
                    loadonce: false,
                    initialState: 'collapsed',
//                    nowrap: false, // this will allow the text wrap but it looks bad
                    columns: [[
                            {title: 'Name', field: 'name', width: '63%', formatter: function (value) {
                                    // return ' <img src="<c:url value='/recursos/js/treeGrid/target.svg'/>" style="width:16px;height:18px;vertical-align:bottom"/> ' +  value;
                                    return  value;
                                }},
                            {title: 'PP', field: 'noofplannedlessons', width: '5%', align: 'center'},
                            {title: 'PD', field: 'noofarchivedlessons', width: '5%', align: 'center'},
                            {title: 'Progress', field: 'progress', width: '16%', align: 'center', formatter: formatProgress},
                            {title: 'Final rating', field: 'rating', width: '13.5%', align: 'center'}
                        ]]

                });
                $(".datagrid-btable tbody>tr td[field*='name'] >div>span[class*='tree-title']").each(function (index) {
                    //  console.log( index + ": " + $( this ).text() );
                    /*  var img;
                     if ($(this).parent().parent().parent().attr("node-id")[0] === "L")
                     img = "subject.png";
                     else if ($(this).parent().parent().parent().attr("node-id")[0] === "C")
                     img = "target.png";
                     else
                     img = "step.png";
                     */
                    var text = $(this).text();
                    var fontSize = 12;
                    var fontHeight = 1.58;
                    var MAX_CHAR_ROW = Math.round(parseInt($(this).parent().css("width")) / (fontSize / fontHeight)) - 7;


                    if (text.length > MAX_CHAR_ROW) {
                        var aux = 0;
                        var textIzq = "", textDer = "";

                        for (var i = 0; i < text.length; ++i) {
                            if (text[i] === " ")
                                aux = i;
                            if (i !== 0 && i % MAX_CHAR_ROW === 0) {
                                textDer = text.substr(aux, (text.length));
                                textIzq = text.substr(0, aux);
                                // text = textIzq +" <br> "+ textDer;

                                $(this).html(textIzq + '<br>' + textDer);
                                //  $(this).text(text);
                                $(this).css("height");
                                $(this).css("height", $(this).css("height") * 2);

                            }
                        }
                    }
                    // jQuery("<img/> ").prependTo($(this)).attr({src: '../recursos/js/treeGrid/' + img + '', width: '16px', height: '18px', style: 'padding-right:5px;'});

                });
                //jQuery("<img/>").prependTo(".datagrid-btable tbody>tr td[field*='name'] >div>span[class*='tree-title']").attr({src: '../recursos/js/treeGrid/target.svg', width:'16px', height:'18px'});

                //


                $('#loadingmessage').hide();
                // $("#tg").treegrid('collapseAll');
                $('.datagrid-row').mouseover(function () {
                    $(this).attr("title", $(this).first().children().first().children().last().children().last().text());
                });
                if (pActual === "")
                    pActual = "Demographic";
                $('#' + pActual).tab('show');


            }

            function funcionCallBackSelectStudent()
            {
                if (ajax.readyState === 4) {

                    if (ajax.status === 200) {
                        //data
                        var json = JSON.parse(ajax.responseText);
                        var info = JSON.parse(json.info);
                        var foto = JSON.parse(json.prueba);
                        var prog = JSON.parse(json.prog);
                        var subjects = JSON.parse(json.sub);
                        var nextPresentations = JSON.parse(json.nextPresentations);

                        $('#gradelevel').text(info.level_id);
                        $('#nextlevel').text(info.nextlevel);
                        $('#student').text(info.nombre_students);
                        $('#studentid').val(info.id_students);
                        $('#BOD').text(info.fecha_nacimiento);
                        $("#TXTsupervisorComment").val(json.commentHead);
                        $("#commentSubject").val("");
                        if (typeof info.foto === 'undefined' || info.foto === "") {
                            $('#foto').attr('src', '../recursos/img/NotPhoto.png');
                        } else {
                            $('#foto').removeAttr('src');
                            $('#foto').attr('src', foto);
                        }

                        $('.cell').off('click');
                        //treeload(info.level_id, info.id_students);
                        treeload2(prog);
                        levelarbol = info.level_id;
                        studentarbol = info.id_students;
                        //hide the objectives in case a previous student was selected
                        $('#divTableObjective').addClass('hidden'); //to avoid having the general comments of the previous selected student
                        $('#divNotObjective').addClass('hidden');
                        $('#subjects').empty();
                        $('#subjects').append('<option value ="-1">Select Subject</option>');
                        $.each(subjects, function (i, item) {
                            if (subjects[i].name !== undefined)
                                $('#subjects').append('<option value= "' + subjects[i].id + '">' + subjects[i].name + '</option>');
                        });

                        sortSelect("subjects");
                        $("#subjects").val(-1);

                        $('#subjectsReports').empty();
                        $('#subjectsReports').append('<option value ="-1">Select Subject</option>');
                        $.each(subjects, function (i, item) {
                            if (subjects[i].name !== undefined)
                                $('#subjectsReports').append('<option value= "' + subjects[i].id + '">' + subjects[i].name + '</option>');
                        });

                        sortSelect("subjectsReports");


                        $("#subjectsReports").val(-1)

                        $('#divCommentSubject').removeClass('hidden');
                        $('#saveCommentSubject>i').removeClass('glyphicon-chevron-up');
                        $('#saveCommentSubject>i').addClass('glyphicon-chevron-down');

                        $("#listObjectiveReport tbody").empty();

                        /*var radioButtonCode="";
                         $("#divTerms").empty();
                         
                         
                         $("#termSelect option").each(function () {
                         radioButtonCode +="<label class='radio-inline'><input type='radio' name='opt" + $(this).attr("value") + "'>" + $(this).text() + "</label> ";
                         });
                         radioButtonCode += "<label class='radio-inline'><input type='radio' name='optAll'>All</label>";
                         
                         $("#divTerms").append("<form>"+radioButtonCode+"</form>");*/



                        $("#divTerms").empty();

                        $("#termSelect option").each(function () {
                            $("#divTerms").append("<div class='radio' style='margin-left: 5%;'><label><input  onclick='selectTreeByTerm(" + $(this).attr("value") + ")' type='radio' name='opt'" + $(this).attr("value") + "'>" + $(this).text() + "</label></div>");
                        });
                        $("#divTerms").append("<div class='radio' style='margin-left: 5%;'><label><input onclick='selectTreeByTerm(-1)' type='radio' name='opt' vlaue='all' checked>All</label></div>");

                        $("#divTerms :first").css("margin-left","0px"); // cambiar que se haga en el css
                        
                        $("#nextPresentations").empty();
                        for (var i = 0; i < nextPresentations.length; i++) {
                            var html_Li = " <div class='col-xs-12 nextPresentation'>\n\
                                                    <div class='col-xs-10 sinpadding'>\n\
                                                        <div class='col-xs-12 namePresentation'>" + nextPresentations[i].col2 + "</div> \n\
                                                        <div class='col-xs-12 nameTeacher'>" + nextPresentations[i].col3 + "</div> \n\
                                                    </div>\n\
                                                    <div class='col-xs-2'><span class='badgeGo  sinpadding glyphicon glyphicon-eye-open' title='Progress Presentation' onclick='rowselect(" + nextPresentations[i].col1 + ")'></span></div> \n\
                                                </div>";
                            $("#nextPresentations").append(html_Li);
                        }

                    }
                }
            }
            ;

            function rowselect(LessonsSelected)
            {

                window.open("<c:url value="/lessonprogress/loadRecords.htm?LessonsSelected="/>" + LessonsSelected);
            }

            function selectTreeByTerm(value) {

                var studentId = $('#studentid').val();
                var idSubject = value;

                var myObj = {};
                myObj["idSubject"] = idSubject; //termId
                myObj["idStudent"] = studentId; // studentId
                var json = JSON.stringify(myObj);
                $.ajax({
                    type: 'POST',
                    url: "selectTreeByTerm.htm",
                    data: json,
                    datatype: "json",
                    contentType: "application/json",
                    success: function (data) {
                        var prog = JSON.parse(data);
                        treeload2(prog);
                    },
                    error: function (xhr, ajaxOptions, thrownError) {
                        console.log(xhr.status);
                        console.log(xhr.responseText);
                        console.log(thrownError);
                    }

                });
            }
            function formatProgress(value) {
                if (value) {
                    var s = '<div style="width:100%;border:1px solid #ccc">' +
                            '<div style="width:' + value + '%;background:#cc0000;color:#fff">' + value + '%' + '</div></div>';
                    return s;
                } else {
                    return '';
                }
            }

            function comboSelectionLevelStudent()
            {

                var seleccion = document.getElementById("levelStudent").value;
                $.ajax({
                    type: "POST",
                    url: "studentlistLevel.htm?seleccion=" + seleccion,
                    data: seleccion,
                    dataType: 'text',
                    success: function (data) {
                        var json = JSON.parse(data);
                        //var table = $('#table_students').DataTable();
                        table.clear();
                        $.each(json, function (i) {
                            table.row.add({'id': json[i].id_students, 'name': json[i].nombre_students}).draw();
                        });
                    },
                    error: function (xhr, ajaxOptions, thrownError) {
                        console.log(xhr.status);
                        console.log(xhr.responseText);
                        console.log(thrownError);
                    }

                });
            }

            function modifySelect(LessonsSelected)
            {
                window.open("<c:url value="/editlesson/start.htm?LessonsSelected="/>" + LessonsSelected);
            }

            function comboSelectionLevel()
            {
                if (window.XMLHttpRequest) //mozilla
                {
                    ajax = new XMLHttpRequest(); //No Internet explorer
                } else
                {
                    ajax = new ActiveXObject("Microsoft.XMLHTTP");
                }

                $('#createOnClick').attr('disabled', true);
                ajax.onreadystatechange = funcionCallBackSubject;
                var seleccion1 = document.getElementById("level").value;
                ajax.open("POST", "progressbystudent.htm?option=subjectlistLevel&seleccion1=" + seleccion1, true);
                ajax.send("");
            }
            function showCommentSubject() {
                if ($('#divCommentSubject').hasClass('hidden')) {
                    $('#divCommentSubject').removeClass('hidden');
                    $('#saveCommentSubject>i').removeClass('glyphicon-chevron-down');
                    $('#saveCommentSubject>i').addClass('glyphicon-chevron-up');
                } else {
                    $('#divCommentSubject').addClass('hidden');
                    $('#saveCommentSubject>i').removeClass('glyphicon-chevron-up');
                    $('#saveCommentSubject>i').addClass('glyphicon-chevron-down');
                }
            }

            function saveSupervisorCommentFunction() {

                if (window.XMLHttpRequest) //mozilla
                {
                    ajax = new XMLHttpRequest(); //No Internet explorer
                } else
                {
                    ajax = new ActiveXObject("Microsoft.XMLHTTP");
                }

                var studentId = $('#studentid').val();
                var idSubject = "-1";
                var comment = $("#TXTsupervisorComment").val()

                var myObj = {};
                myObj["idSubject"] = idSubject;
                myObj["idStudent"] = studentId;
                myObj["comment"] = comment;
                var json = JSON.stringify(myObj);
                $.ajax({
                    type: 'POST',
                    url: "saveSubjectComment.htm",
                    data: json,
                    datatype: "json",
                    contentType: "application/json",
                    success: function (data) {
                        $('#confirmsaveSupervisorComment').modal('show');
                    },
                    error: function (xhr, ajaxOptions, thrownError) {
                        console.log(xhr.status);
                        console.log(xhr.responseText);
                        console.log(thrownError);
                    }

                });
            }
            function saveCommentSubjects() {

                if (window.XMLHttpRequest) //mozilla
                {
                    ajax = new XMLHttpRequest(); //No Internet explorer
                } else
                {
                    ajax = new ActiveXObject("Microsoft.XMLHTTP");
                }

                var studentId = $('#studentid').val();
                var idSubject = $('#subjects option:selected').val();
                var comment = $('#commentSubject').val();
                var myObj = {};
                myObj["idSubject"] = idSubject;
                myObj["idStudent"] = studentId;
                myObj["comment"] = comment;
                var json = JSON.stringify(myObj);
                $.ajax({
                    type: 'POST',
                    url: "saveSubjectComment.htm",
                    data: json,
                    datatype: "json",
                    contentType: "application/json",
                    success: function (data) {
                        $('#confirmsaveSubject').modal('show');
                    },
                    error: function (xhr, ajaxOptions, thrownError) {
                        console.log(xhr.status);
                        console.log(xhr.responseText);
                        console.log(thrownError);
                    }

                });
            }

            function selectionStudent()
            {
                var selectStudent = data1;
                if (window.XMLHttpRequest) //mozilla
                {
                    ajax = new XMLHttpRequest(); //No Internet explorer
                } else
                {
                    ajax = new ActiveXObject("Microsoft.XMLHTTP");
                }
                $('#loadingmessage').show(); // show the loading message.
                //$('#createOnClick').attr('disabled', true);
                ajax.onreadystatechange = funcionCallBackSelectStudent;
                //  var selectStudent = document.getElementsByClassName("nameStudent").value;
                ajax.open("POST", "studentPage.htm?selectStudent=" + selectStudent, true);
                ajax.send("");
            }

            function selectionObjective(dataObjective1)
            {
                var selectObjective = dataObjective1;
                var selectStudent = $("#student").text();
                var gradelevel = $("#gradelevel").text();
                var subject = $("#subjects :selected").text();
                var myObj = {};
                myObj["col1"] = selectObjective; //objectiveid
                myObj["col2"] = data1; //studentid
                myObj["col3"] = selectStudent; //studentname
                myObj["col4"] = gradelevel; //gradelevel
                myObj["col5"] = subject; //subject
                var json = JSON.stringify(myObj);
                $.ajax({
                    type: 'POST',
                    url: '<c:url value="/progressdetails.htm"/>',
                    data: json,
                    datatype: "json",
                    contentType: "application/json",
                    success: function (data) {
                        var win = window.open('about:blank');
                        with (win.document)
                        {
                            open();
                            write(data);
                            close();
                        }
                    },
                    error: function (xhr, ajaxOptions, thrownError) {
                        console.log(xhr.status);
                        console.log(xhr.responseText);
                        console.log(thrownError);
                    }

                });
            }

            function loadobjGeneralcomments()
            {
                if ($("#subjects :selected").text() === "Select Subject" || $("#subjects :selected").text() === "") {
                    $("#saveCommentSubjectButton").prop('disabled', true);
                    $("#commentSubject").hide();
                    $("#commentLength").hide();
                    $("#commentSubject").val("");
                    $('#divTableObjective').addClass('hidden');
                } else {
                    if (window.XMLHttpRequest) //mozilla
                    {
                        ajax = new XMLHttpRequest(); //No Internet explorer
                    } else
                    {
                        ajax = new ActiveXObject("Microsoft.XMLHTTP");
                    }
//        var selectSubject = document.getElementById("subjects").value; 
//       var selectStudent = document.getElementById("studentid").value;
//        var d = { selectSubject:selectSubject, studentid:selectStudent};
//                $.ajax({
//            type: 'GET',
//            url: 'objGeneralcomments.htm',
//            contentType: 'application/json; charset=utf-8',
//            data: JSON.stringify(d),
//            dataType: 'json',
//            success: funcionCallBackloadGeneralcomments
//          
//        });
                    ajax.onreadystatechange = funcionCallBackloadGeneralcomments;
                    var selectSubject = document.getElementById("subjects").value;
                    var selectStudent = document.getElementById("studentid").value;
                    ajax.open("POST", "objGeneralcomments.htm?selection=" + selectSubject + "," + selectStudent, true);
                    ajax.send("");
                }
            }
            function saveobservation()
            {
                var observation = $("#observationcomments").val();
                var date = $("#observationfecha").val();
                var type = $("#observationtype :selected").text();
                var studentId = $('#studentid').val();
                if (observation === "" || date === "" || type === "" || studentId === "" || type === "Select type")
                {
                    if (studentId === "") {
                        $('#error1').removeClass('hidden');
                    } else {
                        $('#error2').removeClass('hidden');
                    }
                } else {
                    var myObj = {};
                    myObj["observation"] = observation;
                    myObj["date"] = date;
                    myObj["type"] = type;
                    myObj["studentid"] = studentId;
                    var json = JSON.stringify(myObj);
                    var data = new FormData();
                    data.append("obj", json);
                    data.append("fileToUpload", $('#fileToUpload')[0].files[0]);
                    var path = document.location.href;
                    var i = path.length - 1;
                    for (var j = 0; j < 2; j++) {
                        if (j === 1)
                            path = path.substring(0, i);
                        while (path[i] !== '/') {
                            path = path.substring(0, i);
                            i--;
                        }
                    }
                    path = path + "savecomment";
                    var request = new XMLHttpRequest();
                    request.open("POST", path);
                    request.send(data);
                    $('#confirmsave').modal('show');
                    $("#observationcomments").val("");
                    $("#observationfecha").val("");
                    $("#fileToUpload").val("");
                    $('#observationtype option').filter(function () {
                        return ($(this).text() === 'Select type'); //To select Blue
                    }).prop('selected', true);
                }
            }
            function showCalendar()
                        {
                                var id = $('#studentid').val();
                                var nameStudent = $('#student').text();
                                id = id + "-" + nameStudent;
                                window.open("<c:url value="/progcal.htm?studentid="/>" + id);
                        }

            function loadObjectiveReport() {
                var seleccion = $("#subjectsReports").val();
                var stdId = $("#studentid").val();

                $("#listObjectiveReport tbody").empty();
                if (seleccion !== "Select Subject") {
                    $.ajax({
                        type: "POST",
                        url: "objectiveListReport.htm?seleccion=" + seleccion + "&studId=" + stdId,
                        data: seleccion,
                        dataType: 'text',
                        success: function (data) {
                            var json = JSON.parse(data);
                            var info = JSON.parse(json.result);
                            var ratings = JSON.parse(json.ratings);
                            var levels = JSON.parse(json.levels);


                            for (var i = 0; i < info.length; i++) {
                                $("#listObjectiveReport tbody").append("<tr><td>" + info[i].col1 + "</td>\n\
                                <td>\n\
                                    <select data='" + info[i].col3 + "' class='ratingReport reportGrades'>\n\
                                    " + generateOptionsRatings(ratings, info[i].col2) + "\n\
                                    </select>\n\
                                </td>\n\
                                <td>\n\
                                    <select data='" + info[i].col3 + "' class='selectReport reportGrades'>\n\
                                     " + generateOptionsLevels(levels, info[i].col5) + "\n\
                                    </select>\n\
                                    </td>\n\
                            </tr>")
                            }
                            $(".reportGrades").change(function () {
                                saveObjectiveReport($(this));
                            });
                        },
                        error: function (xhr, ajaxOptions, thrownError) {
                            console.log(xhr.status);
                            console.log(xhr.responseText);
                            console.log(thrownError);
                        }

                    });
                }
            }

            /*
             myObj["col5"] = subject; //subject
             var json = JSON.stringify(myObj);
             $.ajax({
             type: 'POST',
             url: '<c:url value="/progressdetails.htm"/>',
             data: json,
             datatype: "json",*/

            function saveObjectiveReport(target) {
                var newSeleccion = target.val();
                var objectiveId = target.attr("data");
                var rating_select = "level_id";
                if (target.hasClass("ratingReport"))
                    rating_select = "rating_id";

                var myObj = {};
                myObj["col1"] = newSeleccion; //nueva seleccion
                myObj["col2"] = objectiveId; // objective id
                myObj["col3"] = rating_select; // name column
                myObj["col4"] = $("#studentid").val();
                var json = JSON.stringify(myObj);
                $.ajax({
                    type: "POST",
                    url: "updateObjectivesReport.htm",
                    data: json,
                    contentType: "application/json",
                    datatype: "json",
                    success: function (data) {
                        var f = "fd";
                    },
                    error: function (xhr, ajaxOptions, thrownError) {
                        console.log(xhr.status);
                        console.log(xhr.responseText);
                        console.log(thrownError);
                    }

                });
            }
            function generateOptionsRatings(ratings, idRating) {
                var aux = "";
                var selected = "";
                for (var i = 0; i < ratings.length; i++) {
                    if (ratings[i][0] === idRating)
                        selected = "selected=''";
                    aux += "<option " + selected + " value='" + ratings[i][0] + "'>" + ratings[i][1] + "</option>";
                    selected = "";
                }
                return aux;
            }
            function generateOptionsLevels(levels, idLevel) {
                var aux = "";
                var selected = "";
                for (var i = 0; i < levels.length; i++) {
                    if (levels[i][0] === idLevel)
                        selected = "selected=''";
                    aux += "<option " + selected + " value='" + levels[i][0] + "'>" + levels[i][1] + "</option>";
                    selected = "";
                }
                return aux;
            }
//  function funcionCallBacksavecomment(){
//        if (ajax.readyState===4){
//                if (ajax.status===200){
//                    
//                   $('#confirmsave').modal('show');
//                }
//        }
//        }
            $(function () {
                $('#subject').change(function () {
//        $('#LoadTemplates').parent().attr("disabled",false);
//        $('#LoadTemplates').attr("disabled",false);
                    $('#LoadTemplates').children().removeClass("disabled");
                });
                $('#LoadTemplates').change(function () {
                    if ($("input:radio[name='options']:checked").val() === 'option1') {
                        $("#lessons").attr("disabled", true);
                        $('#divCrearLessons').removeClass('hidden');
                        $('#divLoadLessons').addClass('hidden');
//    $("#NameLessons").attr("disabled", true);
                    } else {
                        $("#lessons").attr("disabled", false);
                        $('#divLoadLessons').removeClass('hidden');
                        $('#divCrearLessons').addClass('hidden');
//    $("#NameLessons").attr("disabled", false);
                    }
                });
            });
        </script>

        <style>


            textarea 
            {
                resize: none;
            }

            .studentarea
            {            
                height: 500px;
                width: 100%;
                overflow-y: scroll;
            }
            .nameStudent
            {
                background-color: #D0D2D3;
                border-radius: 10px;
                margin-top: 20px;
                margin-bottom: 20px;
                padding-top: 10px;
                padding-bottom: 10px;
                min-height: 40px;
            }
            .tab-pane
            {
                padding-top: 20px;
            }
            .sinpadding
            {
                padding: 0px;
            }
            .containerPhoto
            {
                display: table;
                /*                background-color: lightgray;*/
                border-right: 1px #D0D2D3 double;
                text-align: center;
                /*min-height: 600px;*/
            }
            .cell{
                display: table-cell;
                vertical-align: middle;
            }
            #divTableObjective{
                margin-top: 20px;
            }
            .label-demographic{
                background-color: lightgray;
                text-align: center;
                padding: 5px;
                border-top-left-radius: 10px;
                border-top-right-radius: 10px;
                margin-bottom: 0px;
            }
            .demographic{
                border: 1px solid lightgray;
                padding: 5px;
                margin-bottom: 10px;
                min-height: 32px;
            }
            .btn-unbutton{
                background-color: Transparent;
                background-repeat:no-repeat;
                border: none;
                cursor:pointer;
                overflow: hidden;
                outline:none;
            }
            .dataTables_length select {

            }
            .dataTables_filter {
                display: block !important;
                float: left !important;
                text-align: left !important;
                padding-left: 0px;
            }
            #divCommentSubject{
                margin-top: 5px;
            }
            .dataTables_filter input {
                display: block;
                float: left;
                width: 100%;
                height: 34px;
                padding: 6px 12px;
                margin-left: 0px !important;
                font-size: 14px;
                line-height: 1.42857143;
                color: #555;
                background-color: #fff;
                background-image: none;
                border: 1px solid #ccc;
                border-radius: 4px;
                -webkit-box-shadow: inset 0 1px 1px rgba(0, 0, 0, .075);
                box-shadow: inset 0 1px 1px rgba(0, 0, 0, .075);
                -webkit-transition: border-color ease-in-out .15s, -webkit-box-shadow ease-in-out .15s;
                -o-transition: border-color ease-in-out .15s, box-shadow ease-in-out .15s;
                transition: border-color ease-in-out .15s, box-shadow ease-in-out .15s;
            }
            div.dataTables_wrapper div.dataTables_filter input 
            {
                display: inline-block !important;
                width: 100% !important;
                margin-bottom: 0;
                margin-left: 0.5em;
            }
            .tree-icon{
                display:none;
            }
            .foto
            {
                width: 75%;
                border-radius: 10px;
            }
            .tree-title {
                font-size: 12px;
                display: inline-flex;
                text-decoration: none;
                vertical-align: top;

                padding-right: 45px;
                height: auto;
                line-height: 18px;
            }
            
            #table_students{
                width: 100% !important;
            }
            .badgeGo{
                cursor: pointer;

                text-align: center;
            }
            .nextPresentation{
                padding: 5px;
                border: solid 1px #cdcdcd;
                display: flex;
                align-items: center;
            }
            .nameTeacher{
                font-size: smaller;
            }
            .namePresentation{
                font-weight: bold;
            }
            img{
                width: auto;
            }
            .radio{  
                margin: 0px;
            }
            .maskFile{
                position: relative;
                top: -22px;
                padding: 0px;
            }
            .maskFile button{
                background-color: #ffffff;
                color: #3074af;
                border-radius: 8px;
                border-color: #2f6fa7;
            }
            .maskFile label{
                font-weight: normal;
                color: #2f6fa7;
                padding-left: 5px;
            }
             #fileToUpload{
                z-index: 1;
                position: relative;
                opacity: 0;
                cursor: pointer;
            }
         
            .colorSuccess{
                color: #2f6fa7;
            }
        </style>
    </head>

    <body>

        <div class="container">
            <h1 class="text-center"><spring:message code="etiq.progressByStudent"/></h1>
            <form:form id="formStudents" >

                <fieldset>
                    <!--                    <legend>Select student</legend>-->
                    <div class="col-xs-3">
                        <div class="col-xs-12 sinpadding">
                            <label><spring:message code="etiq.filter"/></label>
                            <select class="form-control" name="levelStudent" id="levelStudent" style="width: 100% !important;" onchange="comboSelectionLevelStudent()">
                                <c:forEach var="levels" items="${gradelevels}">
                                    <option value="${levels.id[0]}">${levels.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <!--                        <div class="col-xs-12">
                                                    <label>By name</label>
                                                    <input class="form-control" name="nameStudent" id="nameStudent" style="width: 100% !important;" onchange="comboSelectionnameStudent()">
                                                </div>-->
                        <div class="col-xs-12 studentarea">
                            <table id="table_students" class="display" >
                                <thead>
                                    <tr>
                                        <td>ID</td>
                                        <td><spring:message code="etiq.studentName"/></td>
                                    </tr>
                                </thead>
                                <c:forEach var="alumnos" items="${listaAlumnos}" >
                                    <tr>
                                        <td >${alumnos.id_students}</td>
                                        <td >${alumnos.nombre_students}</td>
                                    </tr>
                                </c:forEach>
                            </table>      
                        </div>
                    </div> 

                    <div id="divProgress" class="col-xs-9 hidden sinpadding">
                        <div class="col-xs-12 text-center nameStudent">
                            <span id="student"> </span>
                            <input type="hidden" id="studentid" name="studentid">
                        </div>
                        <div class="col-xs-12 text-center sinpadding" id="myTab">
                            <ul class="nav nav-tabs">
                                <li class="active"><a id="<spring:message code='etiq.demographicProgressID'/>" data-toggle="tab" href="#demographic" role="tab" ><spring:message code="etiq.demographicProgress"/></a></li>
                                <li><a id="<spring:message code="etiq.objectivesProgressID"/>" data-toggle="tab" href="#progress" role="tab"><spring:message code="etiq.objectivesProgress"/></a></li>
                                <li><a id="<spring:message code="etiq.acadProgressID"/>" data-toggle="tab" href="#gradebook" role="tab"><spring:message code="etiq.acadProgress"/></a></li>
                                <li><a id="<spring:message code="etiq.classProgressID"/>" data-toggle="tab" href="#observations" role="tab"><spring:message code="etiq.classProgress"/></a></li>
                                <li><a id="<spring:message code="etiq.reportProgressID"/>" data-toggle="tab" href="#supervisorComment" role="tab"><spring:message code="etiq.reportProgress"/></a></li>
                            </ul>
                        </div>
                        <div class="tab-content">

                            <div role="tabpanel" class="col-xs-12 tab-pane in active" id="demographic">
                                <div class="col-xs-5 text-center containerPhoto">
                                    <div class="col-xs-12 cell">
                                        <img id="foto" src="../recursos/img/NotPhoto.png" class="foto">
                                    </div>   
                                    <div class="col-xs-12 sinpadding">
                                        <div class="col-xs-offset-1 col-xs-10 sinpadding form-group" style="margin-top: 5%;">
                                            <label class="text-left col-xs-6" ><spring:message code="etiq.birthday"/>:</label>
                                            <span class="text-right col-xs-6" id="BOD"></span>
                                        </div>
                                        <div class="col-xs-offset-1 col-xs-10 sinpadding form-group">
                                            <label class="text-left col-xs-6  " ><spring:message code="etiq.GradeLevel"/>:</label>
                                            <span class="text-right col-xs-6 " id="gradelevel"></span>
                                        </div>
                                        <div class="col-xs-offset-1 col-xs-10 sinpadding form-group">
                                            <label class="text-left col-xs-6 " ><spring:message code="etiq.nextLevel"/>:</label>
                                            <span class="text-right col-xs-6 " id="nextlevel"></span>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-xs-7">
                                    <div class="col-xs-12">
                                        <label class="col-xs-12 sinpadding"><spring:message code="etiq.upPrese"/>:</label>

                                        <div id="nextPresentations" class="col-xs-12">

                                        </div>
                                    </div>  
                                </div>
                            </div>
                            <div role="tabpanel" class="col-xs-12 tab-pane" id="progress">
                                <div class="col-xs-12 sinpadding">
                                    <div class="col-xs-12 sinpadding"><p class="text-info"><Strong><spring:message code="etiq.pp"/>:</Strong> <spring:message code="etiq.ppDescr"/></p></div>
                                    <div class="col-xs-12 sinpadding"><p class="text-info"><Strong><spring:message code="etiq.pd"/>:</Strong> <spring:message code="etiq.pdDescr"/></p></div>
                                    <!--<div class="col-xs-12 sinpadding">
                                    <!--<p class="text-info"><Strong>PD:</Strong> Presentations done.</p>-->
                                    <!--<div class="row" style="display: flex;justify-content: space-between;">
                                        <p class="col-xs-4 text-info"><strong>PD:</strong> Presentations done.</p>
                                      

                                    <!--<div class="form-check">
                                        <input class="form-check-input" name="exampleRadios" id="exampleRadios1" value="option1" type="radio">
                                        <label class="form-check-label" for="exampleRadios1">Term1</label>
                                    </div>
                                    <div class="form-check">
                                        <input class="form-check-input" name="exampleRadios" id="exampleRadios2" value="option2" type="radio">
                                        <label class="form-check-label" for="exampleRadios2">Term2</label>
                                    </div>
                                    <div class="form-check">
                                        <input class="form-check-input" name="exampleRadios" id="exampleRadios1" value="option1" type="radio">
                                        <label class="form-check-label" for="exampleRadios1">Term3</label>
                                    </div>
                                    <div class="form-check">
                                        <input class="form-check-input" name="exampleRadios" id="exampleRadios2" value="option2" type="radio">
                                        <label class="form-check-label" for="exampleRadios2">Term4</label>
                                    </div>
                                    <div class="form-check">
                                        <input class="form-check-input" name="exampleRadios" id="exampleRadios1" value="option1" checked="" type="radio">
                                        <label class="form-check-label" for="exampleRadios1">All</label>
                                    </div>-->



                                    <div class="col-xs-12 sinpadding" id="collapseTree">
                                        <div class="col-xs-9 sinpadding text-left" id="divTerms" style="display: flex;justify-content: end;align-items: baseline;"></div>
                                        <div class="col-xs-3 sinpadding text-right">
                                            <p class="text-info" style="margin-bottom: 2px;cursor: pointer;">
                                                <spring:message code="etiq.collapseTree"/>
                                                <span class="glyphicon glyphicon-triangle-top" aria-hidden="true"></span>
                                            </p>
                                        </div>
                                    </div>
                                </div>  
                            
                            <div class="col-xs-12">
                                <div class="row" id="containerTG">
                                    <table id="tg" class="easyui-treegrid"></table>
                                </div>
                            </div>     
                        </div>
                        <div role="tabpanel" class="col-xs-12 tab-pane" id="gradebook">
                            <div class="col-xs-12">
                                <div class="col-xs-10" >
                                    <Label><spring:message code='etiq.txtsubject'/></Label>
                                    <button type='button' class='btn-link editResource' onclick='showCommentSubject()' data-toggle='tooltip' data-placement='bottom' value='<spring:message code='etiq.edit'/>' id='saveCommentSubject'>
                                        <i class='glyphicon glyphicon-chevron-down'></i>
                                    </button>
                                    <select class="form-control" id="subjects" onchange="loadobjGeneralcomments()">
                                    </select>
                                </div>
                                <!--<div class=" col-xs-2 center-block form-group paddingLabel">
                                    <input type="button" name="saveCommentSubject" value="save" class="btn btn-success" id="saveCommentSubject" data-target=".bs-example-modal-lg" onclick="showCommentSubject()"/> 
                                    
                                </div>-->
                            </div>
                            <div class="col-xs-12 hidden" id="divCommentSubject">
                                <div class="col-xs-10 center-block form-group">

                                    <textarea class="form-control" name="TXTCommentSubject" id="commentSubject"  placeholder="<spring:message code='etiq.commentSubject'/>" maxlength="1000"  spellcheck="true"></textarea>
                                </div>             
                                <div class=" col-xs-2" id="saveLengthDiv">
                                    <div class="col-xs-12">
                                        <input type="button" name="saveCommentSubject" value="<spring:message code='etiq.save'/>" class="btn btn-info" id="saveCommentSubjectButton" data-target=".bs-example-modal-lg" onclick="saveCommentSubjects()"/> 
                                    </div>
                                    <div class="col-xs-12" id="commentLength">

                                    </div>
                                </div>
                            </div>

                            <div class="col-xs-12 hidden" id="divNotObjective">
                                <spring:message code='etiq.selectSubjectNoObjec'/>
                            </div>

                            <div class="col-xs-12 hidden" id="divTableObjective">
                                <table id="tableobjective" class="display">
                                    <thead>
                                        <tr>
                                            <th><spring:message code='etiq.txtname'/></th>
                                            <th><spring:message code='etiq.txtdescription'/></th>
                                            <th><spring:message code='etiq.mostRecentComment'/></th>
                                            <th><spring:message code='etiq.lastdate'/></th>
                                            <th></th>
                                        </tr>
                                    </thead> 
                                </table>

                            </div>
                            <div id="confirmsaveSubject" class="modal fade" role="dialog">
                                <div class="modal-dialog">

                                    <!-- Modal content-->
                                    <div class="modal-content">
                                        <div class="modal-header modal-header-delete">
                                            <button type="button" class="close" data-dismiss="modal">&times;</button>
                                            <h4 class="modal-title"><spring:message code='etiq.commentSaved'/></h4>
                                        </div>

                                    </div>

                                </div>
                            </div> 

                        </div>
                        <div role="tabpanel" class="col-xs-12 tab-pane" id="observations">
                            <div class="col-xs-12 text-center">
                                <h2><spring:message code='etiq.enterClassObs'/></h2>
                            </div>
                            <div class='col-xs-6 form-group'>
                                <label class="control-label" for="fecha"><spring:message code='etiq.Date'/></label>
                                <div class='input-group date' id='fecha'>
                                    <input type='text' name="TXTfecha" class="form-control" id="observationfecha"/>
                                    <span class="input-group-addon">
                                        <span class="glyphicon glyphicon-calendar"></span>
                                    </span>
                                </div>
                            </div>
                            <div class="col-xs-6 center-block form-group">
                                <label class="control-label"><spring:message code='etiq.observationType'/></label>
                                <select class="form-control" name="observationtype" id="observationtype" >
                                    <option value="" selected><spring:message code='etiq.selectType'/></option> <!--if you change this value must change as well in savecomment function-->
                                    <option value="Physical"><spring:message code='etiq.physical'/></option>
                                    <option value="Intellectual"><spring:message code='etiq.intellectual'/></option>
                                    <option value="Literacy"><spring:message code='etiq.literacy'/></option>
                                    <option value="Emotional"><spring:message code='etiq.emotional'/></option>
                                    <option value="Social"><spring:message code='etiq.social'/></option>
                                </select>
                            </div>
                            <div class="col-xs-12 center-block form-group">
                                <label class="control-label"><spring:message code='etiq.observation'/></label>
                                <textarea class="form-control" name="TXTdescription" id="observationcomments" placeholder="<spring:message code='etiq.addObservation'/>" maxlength="1000"  spellcheck="true"></textarea>
                            </div>

                            <div class="col-xs-12" >
                                <input type="file" id="fileToUpload" accept="image/*">
                                <div class="col-xs-12 text-left maskFile" >
                                                    <button> 
                                                        <spring:message code="etiq.upload"/> 
                                                        <span class="glyphicon glyphicon-cloud-upload" aria-hidden="true"></span> 
                                                    </button>
                                                    <label> 
                                                        <spring:message code="etiq.fileNotFound"/>
                                                    </label>
                                                </div>
                            </div>
                            <div class="col-xs-12 text-center hidden" id="error1">
                                <label><spring:message code='etiq.pleaseSelect'/></label>
                            </div>
                            <div class="col-xs-12 text-center hidden" id="error2">
                                <label><spring:message code='etiq.pleaseMake'/></label>
                            </div>

                            <div class="col-xs-6 text-center">
                                <button type="button" class="btn btn-success" id="savecomment"  value="<spring:message code='etiq.save'/>" onclick="saveobservation()"><spring:message code='etiq.saveObservation'/></button>
                            </div>

                            <div class="col-xs-6 text-center">
                                <button type='button' class='btn btn-info' id="showcalendar"  value="<spring:message code='etiq.viewAll'/>" onclick="showCalendar()"><spring:message code='etiq.viewAll'/></button>
                            </div>
                            <div id="confirmsave" class="modal fade" role="dialog">
                                <div class="modal-dialog">

                                    <!-- Modal content-->
                                    <div class="modal-content">
                                        <div class="modal-header modal-header-delete">
                                            <button type="button" class="close" data-dismiss="modal">&times;</button>
                                            <h4 class="modal-title"><spring:message code='etiq.commentSaved'/></h4>
                                        </div>

                                    </div>

                                </div>
                            </div> 

                        </div>
                        <div role="tabpanel" class="col-xs-12 tab-pane" id="supervisorComment">
                            <div class="col-xs-12 text-center">
                                <h2><spring:message code='etiq.enterSuperComment'/></h2>
                            </div>
                            <div class="col-xs-12 center-block form-group">
                                <textarea class="form-control" name="TXTdescription" id="TXTsupervisorComment" placeholder="<spring:message code='etiq.addComment'/>" maxlength="1000"  spellcheck="true"></textarea>
                            </div>
                            <div id="divReport" class="col-xs-12 text-center">
                                <div class="col-xs-12" style="   margin-bottom:  10px;   display:  flex;    align-items: center;">
                                    <div class="col-xs-12 col-md-7 sinpadding">
                                        <select class="form-control" id="subjectsReports" onchange="loadObjectiveReport()">
                                            <option value="-1"><spring:message code='etiq.selectSubject'/></option>
                                            <!--<option value="374">Physical Education</option>
                                            <option value="410">Drama</option>
                                            <option value="368">Life Skills</option>
                                            <option value="405">Social and Emotional Development</option>
                                            <option value="356">Creative Movement</option>
                                            <option value="371">Music</option>
                                            <option value="354">Art</option>
                                            <option value="404">Fine Motor Skills</option>
                                            <option value="403">Gross Motor Skills</option>
                                            <option value="389">History</option>
                                            <option value="386">Biology</option>
                                            <option value="377">Physical Science</option>
                                            <option value="362">Knowledge and Understanding of the World</option>
                                            <option value="348">Mathematics</option>
                                            <option value="380">Xhosa</option>
                                            <option value="351">Afrikaans</option>
                                            <option value="365">English</option>
                                            <option value="305">Lunch and Play time</option>-->
                                        </select>
                                    </div>
                                    <div class="col-xs-12 col-md-5 sinpadding">
                                        <form>
                                            <div class="form-group col-xs-12" style=" padding-right:  0px;  display:  flex;  align-items: center;margin-bottom: 0px;">
                                                <label for="staticEmail" class="col-xs-4 col-form-label" style="  margin-bottom:  0px;"><spring:message code='etiq.nota'/>:</label>
                                                <div class="col-xs-8 sinpadding">
                                                    <input disabled="" type="text" readonly class="form-control-plaintext" id="gradeSubject" value="" style=" width:  100%;">
                                                </div>
                                            </div>
                                        </form>
                                    </div>
                                </div>
                                <div class=" col-xs-12">
                                    <table class="table table-bordered" id="listObjectiveReport">
                                        <thead>
                                            <tr>
                                                <th><spring:message code='etiq.Objective'/></th>
                                                <th><spring:message code='etiq.rating'/></th>
                                                <th><spring:message code='etiq.level'/></th>
                                            </tr>
                                        </thead>
                                        <tbody>

                                        </tbody>
                                    </table>
                                </div>

                            </div> 

                            <div class="col-xs-12  text-center">
                                <button type="button" class="btn btn-info" id="saveSupervisorComment"  value="<spring:message code='etiq.save'/>" onclick="saveSupervisorCommentFunction()"><spring:message code='etiq.commentSaved'/></button>
                            </div>


                            <div id="confirmsaveSupervisorComment" class="modal fade" role="dialog">
                                <div class="modal-dialog">

                                    <!-- Modal content-->
                                    <div class="modal-content">
                                        <div class="modal-header modal-header-delete">
                                            <button type="button" class="close" data-dismiss="modal">&times;</button>
                                            <h4 class="modal-title"><spring:message code='etiq.commentSaved'/></h4>
                                        </div>

                                    </div>

                                </div>
                            </div> 

                        </div>

                    </div>
            </div>
        </fieldset>
    </form:form>
    <div>

    </div>
</div>

<div class="divLoadStudent" id="loadingmessage">
    <div class="text-center"> 
        <img class="imgLoading" src='../recursos/img/large_loading2.gif'/>
    </div>
</div>

<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <!--        <h4 class="modal-title" id="myModalLabel">Modal title</h4>-->
            </div>
            <div class="modal-body text-center">
                <H1><%= request.getParameter("message")%></H1>
            </div>
            <!--      <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                    <button type="button" class="btn btn-primary">Save changes</button>
                  </div>-->
        </div>
    </div>
</div>


<div id="modalCommentGeneral">
    <!-- Button trigger modal -->
    <button type="button" class="btn btn-primary btn-lg hidden" data-toggle="modal" data-target="#modalComment" id="showModalComment">
        Launch demo modal
    </button>   
    <!-- Modal -->
    <div class="modal fade" id="modalComment" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title" id="titleComment"></h4>
                </div>
            </div>
        </div>
    </div>
</div>




</body>
</html>
