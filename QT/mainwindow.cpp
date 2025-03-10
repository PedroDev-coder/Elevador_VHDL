#include "mainwindow.h"
#include "ui_mainwindow.h"

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
    , ui(new Ui::MainWindow)
{
    ui->setupUi(this);
    this->setFixedSize(230, 240); // Define um tamanho fixo de 800x600 pixels
    this->setWindowFlags(Qt::Window | Qt::WindowCloseButtonHint);
    this->setWindowTitle("Elevador");

    for(auto p : QSerialPortInfo::availablePorts()){
        ui->comboBoxPort->addItem(p.portName());
    }

    QStringList bauds;
    bauds << "9600";
    ui->comboBoxBaud->insertItems(0,bauds);
}

MainWindow::~MainWindow()
{
    delete ui;
}

void MainWindow::on_conectButton_clicked()
{
    if(this->serial.isOpen()){
        this->serial.close();
        ui->status->setText("Status: Desconectado");
        ui->conectButton->setText("Conectar");
        return;
    }
    serial.setPortName(ui->comboBoxPort->currentText());
    serial.setBaudRate(ui->comboBoxBaud->currentText().toUInt());

    if (serial.open(QIODevice::ReadWrite)){
        ui->status->setText("Status: Conectado");
        ui->conectButton->setText("Desconectar");
    }else{
        ui->status->setText("Status: Falha ao Conectar!!");
    }
}


void MainWindow::on_upButton_clicked()
{
    QByteArray valor = "}";  // Criando um array de bytes válido
    this->serial.write(valor);
}


void MainWindow::on_downButton_clicked()
{
    QByteArray valor = "~";  // Criando um array de bytes válido
    this->serial.write(valor);
}

