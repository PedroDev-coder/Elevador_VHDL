#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <QSerialPort>
#include <QSerialPortInfo>
#include <QDebug>

QT_BEGIN_NAMESPACE
namespace Ui {
class MainWindow;
}
QT_END_NAMESPACE

class MainWindow : public QMainWindow
{
    Q_OBJECT
    
public:

    MainWindow(QWidget *parent = nullptr);
    ~MainWindow();

private slots:
    void on_conectButton_clicked();

    void on_upButton_clicked();

    void on_downButton_clicked();

private:
    Ui::MainWindow *ui;
    QSerialPort serial;
};
#endif // MAINWINDOW_H
